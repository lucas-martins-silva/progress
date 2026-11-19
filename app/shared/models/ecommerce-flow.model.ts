export interface IEcommerceFlow {
    statusCode: number;
    statusDateTime: Date;
    invoiceNumber: string;
}

export class EcommerceFlow implements IEcommerceFlow {
    statusCode: number;
    statusDateTime: Date;
    invoiceNumber: string;

    constructor(values: any) {
        Object.assign(this, values);
    }

    get $statusCode(): number {
        return this.statusCode;
    }

    get $statusDateTime(): Date {
        return this.statusDateTime;
    }

    get $invoiceNumber(): string {
        return this.invoiceNumber;
    }
}
