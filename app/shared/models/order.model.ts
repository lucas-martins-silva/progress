import { Invoice } from './invoice.model';
import { OrderItems } from './orderItems.model';

export interface IOrder {
	orderId: number;
	orderSituation: number;
	customerOrderId: number;
	representativeOrderId: string;
	shortName: string;
	personalId: string;
	implantationDate: Date;
	carrierName: string;
	branchId: number;
	branchName: string;
	deliveryPlace: string;
	deliveryNeighborhood: string;
	deliveryCity: string;
	deliveryState: string;
	deliveryZipCode: string;
	descBusinessModel: string;
	representativeName: string;
	totalOrderAmount: number;
	totalDiscount: number;
	valueFreight: number;
	orderItems: OrderItems;
	invoice: Invoice;
	storeName: string;
}

export class Order implements IOrder {
	orderId: number;
	orderSituation: number;
	customerOrderId: number;
	representativeOrderId: string;
	shortName: string;
	personalId: string;
	implantationDate: Date;
	carrierName: string;
	branchId: number;
	branchName: string;
	deliveryPlace: string;
	deliveryNeighborhood: string;
	deliveryCity: string;
	deliveryState: string;
	deliveryZipCode: string;
	descBusinessModel: string;
	representativeName: string;
	totalOrderAmount: number;
	totalDiscount: number;
	valueFreight: number;
	orderItems: OrderItems;
	invoice: Invoice;
	storeName: string;

	constructor(values: any) {
		Object.assign(this, values);
	}

	get $orderId(): number {
		return this.orderId;
	}

	get $orderSituation(): number {
		return this.orderId;
	}

	get $customerOrderId(): number {
		return this.customerOrderId;
	}

	get $representativeOrderId(): string {
		return this.representativeOrderId;
	}

	get $shortName(): string {
		return this.shortName;
	}

	get $personalId(): string {
		return this.personalId;
	}

	get $implantationDate(): Date {
		return this.implantationDate;
	}

	get $carrierName(): string {
		return this.carrierName;
	}

	get $branchId(): number {
		return this.branchId;
	}

	get $branchName(): string {
		return this.branchName;
	}

	get $deliveryPlace(): string {
		return this.deliveryPlace;
	}

	get $deliveryNeighborhood(): string {
		return this.deliveryNeighborhood;
	}

	get $deliveryCity(): string {
		return this.deliveryCity;
	}

	get $deliveryState(): string {
		return this.deliveryState;
	}

	get $deliveryZipCode(): string {
		return this.deliveryZipCode;
	}

	get $descBusinessModel(): string {
		return this.descBusinessModel;
	}

	get $representativeName(): string {
		return this.representativeName;
	}

	get $totalOrderAmount(): number {
		return this.totalOrderAmount;
	}

	get $totalDiscount(): number {
		return this.totalDiscount;
	}

	get $valueFreight(): number {
		return this.valueFreight;
	}

	get $orderItems(): OrderItems {
		return this.orderItems;
	}

	get $invoice(): Invoice {
		return this.invoice;
	}

	get $storeName(): string {
		return this.storeName;
	}
}
