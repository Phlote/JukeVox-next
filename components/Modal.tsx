interface Modal {
  onClose: () => void;
  open: boolean;
}

export const Modal: React.FC<Modal> = ({ children, onClose, open }) => {
  if (!open) return null;
  return (
    <div className="absolute inset-0 flex items-center justify-center bg-gray-700 bg-opacity-50">
      <div className="absolute h-screen w-full z-9" onClick={onClose}></div>
      <div className="max-w-2xl z-10">
        <div className="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 max-w-lg relative">
          <button onClick={onClose} className="absolute right-3 top-1">
            X
          </button>
          {children}
        </div>
      </div>
    </div>
  );
};
