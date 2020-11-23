import { BlobServiceClient } from '@azure/storage-blob';
import express from 'express';

const app = express();
const port = 8080;

app.get('/', async (req, res) => {
  const blobServiceClient = BlobServiceClient.fromConnectionString(
    'BlobEndpoint=https://devfilestoragemug.blob.core.windows.net/;QueueEndpoint=https://devfilestoragemug.queue.core.windows.net/;FileEndpoint=https://devfilestoragemug.file.core.windows.net/;TableEndpoint=https://devfilestoragemug.table.core.windows.net/;SharedAccessSignature=sv=2019-12-12&ss=b&srt=sco&sp=rl&se=2020-12-31T05:02:09Z&st=2020-11-22T21:02:09Z&spr=https&sig=LccZ0eMYSNtGM4Gz4%2Bks054frq2dv0NPZUPdSg2AljE%3D',
  );

  const containerClient = blobServiceClient.getContainerClient(
    'storagecontainer',
  );

  let blobList = [];
  let i = 1;
  
  for await (const blob of containerClient.listBlobsFlat()) {
    blobList.push(`Blob ${i++}: ${blob.name}`);
  }

  res.send(JSON.stringify(blobList));

});

app.listen(port, () => console.log(`Listening on port ${port}!`));
