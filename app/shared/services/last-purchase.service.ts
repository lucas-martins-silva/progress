import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TotvsResponse } from 'dts-backoffice-util';
import { LastPurchase, lastPurchase } from '../models/last-purchase.model';

@Injectable()
export class LastPurchaseService{
	private apiUrlLastPurchase = '/api/ccp/v1/quotationProcess/lastpurchases';

	constructor( private http: HttpClient ) { }

	getLastPurchase(itemName: string, orderId: string, supplierUnity: string, supplierId: string): Observable<TotvsResponse<LastPurchase>> {
		let url = this.apiUrlLastPurchase + `/${itemName}/${orderId}/${supplierUnity}/${supplierId}`;

		return this.http.get<TotvsResponse<LastPurchase>>(url);
	}
}
