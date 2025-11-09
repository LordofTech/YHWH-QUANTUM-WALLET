
import { Router } from 'express';
import swaggerUi from 'swagger-ui-express';
import * as fs from 'fs';
import * as path from 'path';

const router = Router();
const specPath = path.join(__dirname, '..', 'openapi', 'openapi.json');
const document = JSON.parse(fs.readFileSync(specPath, 'utf-8'));

router.use('/', swaggerUi.serve, swaggerUi.setup(document));

export default router;
