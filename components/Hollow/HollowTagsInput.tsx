import Image from "next/image";
import React, { useState } from "react";
import styled from "styled-components";
import tw from "twin.macro";
import { HollowInput, HollowInputContainer } from ".";

interface TagsInput {
  value: string[];
  onChange: (tags: string[]) => void;
}

// TODO: make this more general where you can pass an styled input
export const HollowTagsInput: React.FC<TagsInput> = ({
  value = [],
  onChange,
}) => {
  const [input, setInput] = useState("");

  const [isKeyReleased, setIsKeyReleased] = useState(false);

  const localOnChange = (e) => {
    const { value } = e.target;
    setInput(value);
  };

  const onKeyDown = (e) => {
    const { key } = e;
    const trimmedInput = input.trim();

    const activeKey = key === "," || key === "Enter";

    if (activeKey && trimmedInput.length && !value.includes(trimmedInput)) {
      e.preventDefault();
      // setTags((prevState) => [...prevState, trimmedInput]);
      onChange([...value, trimmedInput]);
      setInput("");
    }

    if (key === "Backspace" && !input.length && value.length && isKeyReleased) {
      e.preventDefault();
      const tagsCopy = [...value];
      const poppedTag = tagsCopy.pop();

      onChange(tagsCopy);
      setInput(poppedTag);
    }

    setIsKeyReleased(false);
  };

  const onKeyUp = () => {
    setIsKeyReleased(true);
  };

  const deleteTag = (index) => {
    onChange(value.filter((tag, i) => i !== index));
  };

  return (
    <div>
      <HollowInputContainer type="form">
        <HollowInput
          value={input}
          placeholder={
            value.length === 0 ? "Tags (Seperate tags with commas)" : ""
          }
          onKeyDown={onKeyDown}
          onKeyUp={onKeyUp}
          onChange={localOnChange}
        ></HollowInput>
      </HollowInputContainer>
      {value && (
        <>
          <div className="h-3" />
          <div className="flex pl-1 flex-wrap w-full gap-4">
            {value.map((tag, index) => (
              <Tag key={`${tag}${index}`}>
                {tag}
                <div className="w-1" />
                <Image
                  className="cursor-pointer"
                  onClick={() => deleteTag(index)}
                  src="/close.svg"
                  alt="delete"
                  height={12}
                  width={12}
                />
              </Tag>
            ))}
          </div>
        </>
      )}
    </div>
  );
};

const Tag = styled.div`
  border: 2px solid #e8eaee;
  ${tw`flex justify-center items-center bg-white py-2 px-3 box-border rounded text-black h-8`}
`;
