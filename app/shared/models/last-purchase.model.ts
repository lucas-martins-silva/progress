export interface lastPurchase {
	supplierCNPJ: string,
	purchaseDate: Date,
	supplierId: string,
	unitOfMeasure: string,
	paymentCondition: string,
	currencyShorthand: string,
	unitOfMeasureDescription: string,
	itemId: string,
	price: number,
	itemDescription: string,
	purchaseRequisitionId: string,
	supplierDescription: string,
	currencyCode: number,
	typeLastPurchase: string,

	unityPriceFormated: string,
	unitsOfMeasureFormated: string
}
export class LastPurchase implements lastPurchase {
	supplierCNPJ: string;
	purchaseDate: Date;
	supplierId: string;
	unitOfMeasure: string;
	paymentCondition: string;
	currencyShorthand: string;
	unitOfMeasureDescription: string;
	itemId: string;
	price: number;
	itemDescription: string;
	purchaseRequisitionId: string;
	supplierDescription: string;
	currencyCode: number;
	typeLastPurchase: string;

	unityPriceFormated: string;
	unitsOfMeasureFormated: string
	constructor(values: any) {
		Object.assign(this, values);
	}

	public autoFormat(): void {
		this.doUnityPriceFormated();
		this.doUnitsOfMeasureFormated();
	}

	private doUnityPriceFormated(): void{
		this.unityPriceFormated = `${this.currencyShorthand} ${this.price.toLocaleString('pt-br', {style: 'decimal', minimumFractionDigits: 2})}`; 
	}

	private doUnitsOfMeasureFormated(): void{
		this.unitsOfMeasureFormated = `${this.unitOfMeasure} - ${this.unitOfMeasureDescription}`; 
	}

	private doFormated(): void{
		this.unitsOfMeasureFormated = `${this.unitOfMeasure} - ${this.unitOfMeasureDescription}`; 
	}

	get $supplierCNPJ(): string{
		return this.supplierCNPJ;
	}
	get $purchaseDate(): Date{
		return this.purchaseDate;
	}
	get $supplierId(): string{
		return this.supplierId;
	}
	get $unitOfMeasure(): string{
		return this.unitOfMeasure;
	}
	get $paymentCondition(): string{
		return this.paymentCondition;
	}
	get $currencyShorthand(): string{
		return this.currencyShorthand;
	}
	get $unitOfMeasureDescription(): string{
		return this.unitOfMeasureDescription;
	}
	get $itemId(): string{
		return this.itemId;
	}
	get $price(): number{
		return this.price;
	}
	get $itemDescription(): string{
		return this.itemDescription;
	}
	get $purchaseRequisitionId(): string{
		return this.purchaseRequisitionId;
	}
	get $supplierDescription(): string{
		return this.supplierDescription;
	}
	get $currencyCode(): number{
		return this.currencyCode;
	}
}
