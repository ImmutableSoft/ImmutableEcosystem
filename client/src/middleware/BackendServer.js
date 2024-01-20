// Development and Product
export const MemberFileBaseURL = ((window.location.hostname === "localhost") ||
                           (window.location.hostname.split('.').length == 4)) ?
                             "http://localhost:3001/" :
                             "https://members.immutablesoft.org/";
const MemberFileUploadURL = ((window.location.hostname === "localhost") ||
                             (window.location.hostname.split('.').length == 4)) ?
                               "http://localhost:3001/upload" :
                               "https://members.immutablesoft.org/upload";
const MemberFileRemoveURL = ((window.location.hostname === "localhost") ||
                             (window.location.hostname.split('.').length == 4)) ?
                               "http://localhost:3001/remove" :
                               "https://members.immutablesoft.org/remove";

/*
 curl -i -X OPTIONS -H "Origin: http://127.0.0.1:3000" -H 'Access-Control-Request-Method: POST' -H 'Access-Control-Request-Headers: Content-Type, Authorization' "http://127.0.0.1:3001"
*/
  export function UploadFile(fileUpload, entityIndex, productIndex, networkId)
  {

    var data = new FormData();
    data.append('file', fileUpload);
    data.append('network', networkId);
    data.append('user', entityIndex + '-' + productIndex);
    
    // Uploading the file using the fetch API to the server
    return fetch(MemberFileUploadURL, {
      method: 'POST',
      body: data
    }).then((res) => res.json()).then((data) =>
      {
        if (data.success === true)
        {
          // Return the uploaded file's new URI
          return data.fileUrl;
        }
        else
        {
          // Return the error
          return "Error: " + data.message;
        }
      })
      .catch((err) => { return "Error: " + err });
  }

  export function RemoveFile(fileToRemove, entityIndex, productIndex, networkId)
  {
    // entityIndex and productIndex
    var data = new FormData();
    data.append('filename', fileToRemove);
    data.append('network', networkId);
    data.append('user', entityIndex + '-' + productIndex);

    // Removing the file using the fetch API to the server
    return fetch(MemberFileRemoveURL, {
                 method: 'POST',
                 body: data
           }).then((res) => res.json()).then((data) =>
            {
              if (data.success === true)
              {
                // Return the removed file's old URI
                return data.fileUrl;
              }
              else
              {
                // Return the error
                return "Error: " + data.message;
              }
            })
            .catch((err) => { return "Error: " + err });
  }
  
