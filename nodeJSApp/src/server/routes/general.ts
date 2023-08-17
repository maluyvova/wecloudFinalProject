import {
  getAutoCollection,
  saveNewCarToCollection,
  createNewOwner
} from '../controllers/generalController';

const generalRoutes = (app: any) => {


  // get a specific test data
  app.route('/autoCollection/:ownerId').get(getAutoCollection).post(createNewOwner);
  app.route('/newCar').post(saveNewCarToCollection)
};

export default generalRoutes;
