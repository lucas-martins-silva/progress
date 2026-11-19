export interface IPayment {
	paymentMethod: string;
	paymentValue: number;
	quantityOfInstallments: number;
	transactionId: number;
	nsu: number;
}

export class Payment implements IPayment {
	paymentMethod: string;
	paymentValue: number;
	quantityOfInstallments: number;
	transactionId: number;
	nsu: number;

	constructor(values: any) {
		Object.assign(this, values);
	}

	get $paymentMethod(): string {
		return this.paymentMethod;
	}

	get $paymentValue(): number {
		return this.paymentValue;
	}

	get $quantityOfInstallments(): number {
		return this.quantityOfInstallments;
	}

	get $transactionId(): number {
		return this.transactionId;
	}

	get $nsu(): number {
		return this.nsu;
	}
}
