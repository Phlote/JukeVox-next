drop table if exists votes_curator cascade;
drop table if exists comments_curator cascade;

-- Create a table for comments_curator
create table comments_curator (
    id bigserial not null,
    slug text not null unique,
    threadId uuid not null references "Curator_Submission_Table" ("submissionID"),
    "createdAt" timestamp with time zone default now() not null,
    "updatedAt" timestamp with time zone default now() null,
    title text null,
    content text null,
    "isPublished" boolean default false not null,
    "authorId" text not null,
    "parentId" bigint null references comments_curator (id),
    live boolean default true null,
    "isPinned" boolean default false not null,
    "isDeleted" boolean default false not null,
    "isApproved" boolean default true not null,

    primary key (id),
    unique (slug)
);

-- Create a table for votes_curator
create table votes_curator (
    "commentId" bigint not null references comments_curator (id),
    "userId" text not null,
    "value" int not null,

    primary key ("commentId", "userId"),
    constraint vote_quantity check (value <= 1 and value >= -1)
);

-- Set up Realtime!
begin;
  drop publication if exists supabase_realtime;
  create publication supabase_realtime;
commit;
alter publication supabase_realtime add table comments_curator, votes_curator, "Users_Table";


drop view if exists comments_curator_thread_with_user_vote;
drop view if exists comments_curator_thread;
drop view if exists comments_curator_with_author_votes_curator;
drop view if exists comments_curator_linear_view;
drop view if exists comment_with_author;

create view comment_with_author as
    select
        c.id,
        c.slug,
        c."createdAt",
        c."updatedAt",
        c.title,
        c.content,
        c."isPublished",
        c."authorId",
        c."parentId",
        c.live,
        c."isPinned",
        c."isDeleted",
        c."isApproved",
        to_jsonb(u) as author
    from
        comments_curator c
        left join "Users_Table" u on c."authorId" = u.wallet;

create view comments_curator_linear_view as
    select
        root_c.*,
        to_jsonb(parent_c) as parent,
        coalesce(json_agg(children_c) filter (where children_c.id is not null), '[]') as responses
    from
        comment_with_author root_c
        inner join comment_with_author parent_c on root_c."parentId" = parent_c.id
        left join comment_with_author children_c on children_c."parentId" = root_c.id
    group by
        root_c.id,
        root_c.slug,
        root_c."createdAt",
        root_c."updatedAt",
        root_c.title,
        root_c.content,
        root_c."isPublished",
        root_c."authorId",
        root_c."parentId",
        root_c.live,
        root_c."isPinned",
        root_c."isDeleted",
        root_c."isApproved",
        root_c.author,
        parent_c.*;

create or replace view comments_curator_with_author_votes_curator as
    select
        c.id,
        c.slug,
        c."createdAt",
        c."updatedAt",
        c.title,
        c.content,
        c."isPublished",
        c."authorId",
        c."parentId",
        c.live,
        c."isPinned",
        c."isDeleted",
        c."isApproved",
        c."author",
        coalesce (
            sum (v.value) over w,
            0
        ) as "votes_curator",
        sum (case when v.value > 0 then 1 else 0 end) over w as "upvotes_curator",
        sum (case when v.value < 0 then 1 else 0 end) over w as "downvotes_curator"
        -- (select case when auth.uid() = v."userId" then v.value else 0 end) as "userVoteValue"
    from
        comment_with_author c
        left join votes_curator v on c.id = v."commentId"
    window w as (
        partition by v."commentId"
    );

create recursive view comments_curator_thread (
    id,
    slug,
    "createdAt",
    "updatedAt",
    title,
    content,
    "isPublished",
    "authorId",
    "parentId",
    live,
    "isPinned",
    "isDeleted",
    "isApproved",
    "author",
    "votes_curator",
    "upvotes_curator",
    "downvotes_curator",
    "depth",
    "path",
    "pathvotes_curatorRecent",
    "pathLeastRecent",
    "pathMostRecent"
) as
    select
        id,
        slug,
        "createdAt",
        "updatedAt",
        title,
        content,
        "isPublished",
        "authorId",
        "parentId",
        live,
        "isPinned",
        "isDeleted",
        "isApproved",
        "author",
        "votes_curator",
        "upvotes_curator",
        "downvotes_curator",
        0 as depth,
        array[id] as "path",
        array[id] as "pathvotes_curatorRecent",
        array[id] as "pathLeastRecent",
        array[id] as "pathMostRecent"
    from
        comments_curator_with_author_votes_curator
    where
        "parentId" is null
    union
    select
        p1.id,
        p1.slug,
        p1."createdAt",
        p1."updatedAt",
        p1.title,
        p1.content,
        p1."isPublished",
        p1."authorId",
        p1."parentId",
        p1.live,
        p1."isPinned",
        p1."isDeleted",
        p1."isApproved",
        p1."author",
        p1."votes_curator",
        p1."upvotes_curator",
        p1."downvotes_curator",
        p2.depth + 1 as depth,
        p2."path" || p1.id::bigint as "path",
        p2."pathvotes_curatorRecent" || -p1."votes_curator"::bigint || -extract(epoch from p1."createdAt")::bigint || p1.id as "pathvotes_curatorRecent",
        p2."pathLeastRecent" || extract(epoch from p1."createdAt")::bigint || p1.id as "pathLeastRecent",
        p2."pathMostRecent" || -extract(epoch from p1."createdAt")::bigint || p1.id as "pathMostRecent"
    from
        comments_curator_with_author_votes_curator p1
        join comments_curator_thread p2 on p1."parentId" = p2.id;

create or replace view comments_curator_thread_with_user_vote as
    select distinct on (id)
        id,
        slug,
        "createdAt",
        "updatedAt",
        title,
        content,
        "isPublished",
        "authorId",
        "parentId",
        live,
        "isPinned",
        "isDeleted",
        "isApproved",
        "author",
        "votes_curator",
        "upvotes_curator",
        "downvotes_curator",
        "depth",
        "path",
        "pathvotes_curatorRecent",
        "pathLeastRecent",
        "pathMostRecent",
        coalesce(
            (
                select
                    v."value"
                from
                    votes_curator v
                where
                     v."commentId" = id
            ),
            0
        ) as "userVoteValue"
    from comments_curator_thread
