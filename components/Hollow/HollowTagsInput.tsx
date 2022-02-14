import React, { useState } from "react";
import { HollowInput } from ".";
import Image from "next/image";

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
    <div className="flex flex-wrap">
      <ul
        className="inline-flex flex-wrap m-0 p-0 w-full gap-1"
        style={{ paddingLeft: `${tags.length === 0 ? 0 : "1rem"}` }}
      >
        {tags.map((tag, index) => (
          <div
            className="p-1 flex justify-center "
            style={{ backgroundColor: "#1E1E1E" }}
            key={`${tag}${index}`}
          >
            {tag}
            <div className="w-1"></div>
            <button onClick={() => deleteTag(index)}>X</button>
          </div>
        ))}
        <HollowInput
          value={input}
          placeholder={tags.length === 0 ? "Tags" : ""}
          onKeyDown={onKeyDown}
          onKeyUp={onKeyUp}
          onChange={onChange}
        ></HollowInput>
      </ul>
    </div>
  );
};
