import * as Behaviour from './Behaviour';
import * as ActivePosition from '../../behaviour/positioning/ActivePosition';
import * as PositionApis from '../../behaviour/positioning/PositionApis';
import PositionSchema from '../../behaviour/positioning/PositionSchema';
import { PositioningBehaviour } from '../../behaviour/positioning/PositioningTypes';

const Positioning: PositioningBehaviour = Behaviour.create({
  fields: PositionSchema,
  name: 'positioning',
  active: ActivePosition,
  apis: PositionApis
});

export {
  Positioning
};
