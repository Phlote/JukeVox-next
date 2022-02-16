import React, { useState } from "react";
import { HollowInput, HollowInputContainer } from ".";
import Image from "next/image";
import styled from "styled-components";

interface TagsInput {
  tags: string[];
  setTags: (tags: string[]) => void;
}

// TODO: make this more general where you can pass an styled input
export const HollowTagsInput: React.FC<TagsInput> = ({
  tags = [],
  setTags,
}) => {
  const [input, setInput] = useState("");

  const [isKeyReleased, setIsKeyReleased] = useState(false);

  const onChange = (e) => {
    const { value } = e.target;
    setInput(value);
  };

  const onKeyDown = (e) => {
    const { key } = e;
    const trimmedInput = input.trim();

    const activeKey = key === "," || key === "Enter";

    if (activeKey && trimmedInput.length && !tags.includes(trimmedInput)) {
      e.preventDefault();
      // setTags((prevState) => [...prevState, trimmedInput]);
      setTags([...tags, trimmedInput]);
      setInput("");
    }

    if (key === "Backspace" && !input.length && tags.length && isKeyReleased) {
      e.preventDefault();
      const tagsCopy = [...tags];
      const poppedTag = tagsCopy.pop();

      setTags(tagsCopy);
      setInput(poppedTag);
    }

    setIsKeyReleased(false);
  };

  const onKeyUp = () => {
    setIsKeyReleased(true);
  };

  const deleteTag = (index) => {
    setTags(tags.filter((tag, i) => i !== index));
  };

  return (
    <div>
      <HollowInputContainer type="form">
        <HollowInput
          value={input}
          placeholder={tags.length === 0 ? "Tags" : ""}
          onKeyDown={onKeyDown}
          onKeyUp={onKeyUp}
          onChange={onChange}
        ></HollowInput>
      </HollowInputContainer>
      <div className="h-3" />
      <div className="flex pl-1 flex-wrap w-full gap-1">
        {tags.map((tag, index) => (
          <Tag key={`${tag}${index}`}>
            {tag}
            <div className="w-1" />
            <Image
              className="cursor-pointer"
              onClick={() => deleteTag(index)}
              src="/cross.svg"
              alt="delete"
              height={12}
              width={12}
            />
          </Tag>
        ))}
      </div>
    </div>
  );
};

const Tag = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: white;
  padding: 0.5rem 0.75rem;
  border: 2px solid #e8eaee;
  box-sizing: border-box;
  border-radius: 4px;
  color: black;
  height: 2rem;
`;
