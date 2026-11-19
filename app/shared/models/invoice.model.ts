export interface IInvoice {
	siteID: number;
	siteName: string;
	series: number;
	invoiceNumber: number;
	eletronicInvoiceStatus: string;
	danfe: string;
	trackingCode: string;
	trackingURL: string;
}

export class Invoice implements IInvoice {
	siteID: number;
	siteName: string;
	series: number;
	invoiceNumber: number;
	eletronicInvoiceStatus: string;
	danfe: string;
	trackingCode: string;
	trackingURL: string;

	constructor(values: any) {
		Object.assign(this, values);
	}

	get $siteID(): number {
		return this.siteID;
	}

	get $siteName(): string {
		return this.siteName;
	}

	get $series(): number {
		return this.series;
	}

	get $invoiceNumber(): number {
		return this.invoiceNumber;
	}

	get $eletronicInvoiceStatus(): string {
		return this.eletronicInvoiceStatus;
	}

	get $trackingCode(): string {
		return this.trackingCode;
	}

	get $trackingURL(): string {
		return this.trackingURL;
	}

	get $danfe(): string {
		return this.danfe;
	}
}
