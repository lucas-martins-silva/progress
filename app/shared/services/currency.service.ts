import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {PoLookupFilter, PoLookupFilteredItemsParams } from '@po-ui/ng-components';
import { Observable, map } from 'rxjs';


@Injectable()
export class CurrencyZoomService implements PoLookupFilter {

    private apiUrl = '/dts/datasul-rest/resources/prg/cdp/v1/currency';

    constructor(private http: HttpClient) { }

    getFilteredItems(params: PoLookupFilteredItemsParams): Observable<any> {
        let result = {items: []};

        const localParams = Object.assign({}, params.filterParams);        

        let url  = `${this.apiUrl}?$filter=mo-codigo<>0`;

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

        let url = `${this.apiUrl}/${value}?$filter=mo-codigo<>0`;

        return this.http.get(`${url}`).pipe(map((data: any) => {
            return data;
        }));
    }
}
