import {AddItemAction, HighlightItemAction, RemoveItemAction} from '../actions/items';
import {Item} from '../interfaces/item';
import {State} from '../interfaces/state';

export declare const defaultState: never[];
type ActionTypes = AddItemAction | RemoveItemAction | HighlightItemAction | Record<string, never>;
export default function items(state?: Item[], action?: ActionTypes): State['items'];
export {};
//# sourceMappingURL=items.d.ts.map