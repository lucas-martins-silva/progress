import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { TotvsResponse } from 'dts-backoffice-util';

@Injectable()
export class QuotationService {
	private apiUrlQuotationProcess = '/api/ccp/v1/quotationProcess';
	private apiUrlQuotations = '/api/ccp/v1/quotations'

	constructor(private http: HttpClient) { }

	getQuotationProcess(filters: any, processId, vendorId): Observable<TotvsResponse<any>> {
		let url = `${this.apiUrlQuotationProcess}/${processId}/vendors/${vendorId}/quotations`;

		if (filters && filters.length > 0) {

			const urlParams = new Array<string>();

			if (typeof(filters) == 'object') {
				filters.map(filter => {
					urlParams.push(`${filter.property}=${filter.filter}`);
				});
			} else {
				urlParams.push(filters);
			}

			url = `${url}?${urlParams.join('&')}`;
		}

		return this.http.get<TotvsResponse<any>>(url);
	}

	getVendorsOfProcess(processId): Observable<TotvsResponse<any>> {
		let url = `${this.apiUrlQuotationProcess}/${processId}/vendors`;

		return this.http.get<TotvsResponse<any>>(url);
	}

	setDefaults(body) {
		let url = `${this.apiUrlQuotations}/defaults`;

		return this.http.post(url, body);
	}

	delete(id) {
		let url = `${this.apiUrlQuotations}/${id}`;

		return this.http.delete(url);
	}

	quotationsReadjustment(body) {
		let url = `/api/ccp/v1/quotationsReadjustment`;

		return this.http.put(url, body);
	}

	saveQuotations(body) {
		let url = `${this.apiUrlQuotations}/quotationsByProcess`;

		return this.http.put(url, body);
	}
}
