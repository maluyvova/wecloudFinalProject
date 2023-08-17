import { Request, Response } from 'express';
import mongoose from 'mongoose';
import AutoCollection from '../models/autoCollection';

const CollectionDB = mongoose.model('store', AutoCollection);

export const getAutoCollection = (req: Request, res: Response) => {
  pullCollection(req, res);
};


const pullCollection = (req: Request, res: Response) => {
  const filter = { ownerId: req.params.ownerId};
  const db = CollectionDB;
  db.find(filter).lean().exec((err: any, docs: any) => {
    if (err) {
      res.send(err);
    }
    if (docs.length === 0) {
      res.json({
        Error: `didn't find Auto Collection with parameters: {ownerId: ${req.params.ownerId} for ${req.url.split('/')[1]} platform`,
      });
    } else if (docs.length > 1) {
      res.json({
        Error: `Found ${docs.length} Auto Collection which is not supported by this app with parameters {ownerId: ${req.params.ownerId}} for ${req.url.split('/')[1]} platform`,
      });
    } else {
      res.json({
        ownerId: docs[0].ownerId,
        collection: docs[0].store,
      });
    }
  });
};



export const saveNewCarToCollection = (req: Request, res: Response) => {
  // eslint-disable-next-line @typescript-eslint/naming-convention
  const db = CollectionDB;
  let owner_id: string;
  console.log(req.body)
  owner_id = req.body.ownerId;
  const filter = { ownerId: owner_id};
  db.find(filter).lean().exec((err: any, docs: any) => {
    if (err) {
      return err;
    }
    else if (docs.length === 0) {
       console.error(`didn't find collection with owner_id: ${owner_id} }`)
    } else if (docs.length > 1) {
      console.error(`Found ${docs.length} collections`);
    } else {
      db.findOneAndUpdate(
        filter,
        { $push: { store: req.body.store } },
        { new: true, useFindAndModify: false },
        (errs: any) => {
          if (errs) {
            console.error(errs);
          }
        },
      );
      res.status(201);
      res.send('Created');
    }
  });
};

export const createNewOwner = (req: Request, res: Response) => {
  const owner_id = req.params.ownerId;
  const filter = { ownerId: req.params.ownerId };
  const db = CollectionDB;
  db.find(filter).lean().exec((err: any, docs: any) => {
    if (err) {
      return err;
    }
    else if (docs.length >= 1) {
      console.error(`owner with owner_id: ${owner_id} already exists`)
      res.json({
        error: `owner with owner_id: ${owner_id} already exists`,
      });
      return
    } 
    else if (mongoose.connection.readyState === 1) {
      console.log({ ownerId:owner_id, store:req.body })
      const newOwner = new db({ ownerId:owner_id, store:req.body });
      newOwner.save((err: any, docs: any) => {
        if (err) {
          res.send(err);
        }else {
          res.json(docs);
        }
      });
    };
  });
};
