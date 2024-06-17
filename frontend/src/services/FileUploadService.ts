import http from "../http-common";

const upload = (file: File, onUploadProgress: (progressEvent: any) => void): Promise<any> => {
  let formData = new FormData();

  formData.append("file", file);

  return http.post("/upload_file", formData, {
    headers: {
      "Content-Type": "multipart/form-data",
    },
    onUploadProgress,
  });
};

const getFiles = () : Promise<any> => {
  return http.post("/list_uploads");
};

const summarize = () : Promise<any> => {
  return http.post("/summarize_as_text");
};


const FileUploadService = {
  upload,
  getFiles,
  summarize
};

export default FileUploadService;
