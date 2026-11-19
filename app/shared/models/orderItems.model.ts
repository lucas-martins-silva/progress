export interface IOrderItems {
	sequence: number;
	itemCode: string;
	description: string;
	quantityDemanded: number;
	totalValueItem: number;
}

export class OrderItems implements IOrderItems {
	sequence: number;
	itemCode: string;
	description: string;
	quantityDemanded: number;
	totalValueItem: number;

	constructor(values: any) {
		Object.assign(this, values);
	}

	get $sequence(): number {
		return this.sequence;
	}

	get $itemCode(): string {
		return this.itemCode;
	}

	get $description(): string {
		return this.description;
	}

	get $quantityDemanded(): number {
		return this.quantityDemanded;
	}

	get $totalValueItem(): number {
		return this.totalValueItem;
	}
}
