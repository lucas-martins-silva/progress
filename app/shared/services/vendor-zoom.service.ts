import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { PoLookupFilteredItemsParams } from '@po-ui/ng-components';
import { Observable, map } from 'rxjs';

@Injectable()
export class VendorZoomService {
	private apiUrl = '/api/ccp/v1/quotationProcess';

	constructor(private http: HttpClient) { }

    getFilteredItems(params: PoLookupFilteredItemsParams): Observable<any> {

        let result = {items: []};

        const localParams = Object.assign({}, params.filterParams);        

        let url  = `${this.apiUrl}`;

        url += `/${localParams.processId}/vendors`;

        if (params.filter && params.filter.length > 0) {
            url += `/${params.filter}`;
        }        

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

        let url = `${this.apiUrl}/${localParams.processId}/vendors/${value}`;

        return this.http.get(`${url}`).pipe(map((data: any) => {
            if (data.items) {
                return data.items[0];
            } else {
                return data;
            }
        }));
    }
}
