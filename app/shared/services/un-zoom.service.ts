import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { PoDisclaimer, PoLookupFilter, PoLookupFilteredItemsParams } from '@po-ui/ng-components';
import { Observable, map } from 'rxjs';
import { TotvsResponse } from 'dts-backoffice-util';


@Injectable()
export class UNZoomService implements PoLookupFilter {

    private apiUrl = '/api/ccp/v1/itemVendorUnitOfMeasures';

    constructor(private http: HttpClient) { }

    query(itemCode: string, vendorCode: number, filters: PoDisclaimer[], page = 1, pageSize = 20): Observable<TotvsResponse<any>> {

        let url = `${this.apiUrl}?pageSize=${pageSize}&page=${page}&itemCode=${itemCode}&vendorCode=${vendorCode}`;

        if (filters && filters.length > 0) {

            const urlParams = new Array<string>();

            filters.map(filter => {
                urlParams.push(`${filter.property}=${filter.value}`);
            });

            url = `${url}&${urlParams.join('&')}`;
        }

        return this.http.get<TotvsResponse<any>>(url);
    }

    getFilteredItems(params: PoLookupFilteredItemsParams): Observable<any> {
        let result = {items: []};

        const localParams = Object.assign({}, params.filterParams);        

        let url  = `${this.apiUrl}`;

        if (params.filter && params.filter.length > 0) {
            url += `/${params.filter}`;
        }
        
        url += `?itemCode=${localParams.itemCode}&vendorCode=${localParams.vendorCode}`;

        if (localParams.filterZoom && params.filter !== '') {
            url += `&${localParams.filterZoom}=${params.filter}`;
        }

        return this.http.get(url, { params: { page: params.page.toString(), pageSize: params.pageSize.toString() } })
        .pipe(map((data: any) => {
            if (!data.items) {
                result.items.push(data);                
                return result;
            } else {
                return data;
            }
        }));
    }

    getObjectByValue(value: string, filterParams?: any): Observable<any> {        
        const localParams = Object.assign({}, filterParams);

        let url = `${this.apiUrl}/${value}?itemCode=${localParams.itemCode}&vendorCode=${localParams.vendorCode}`;        

        return this.http.get(`${url}`).pipe(map((data: any) => {
            return data;
        }));
    }
}
