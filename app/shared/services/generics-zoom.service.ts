import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { PoDisclaimer, PoLookupFilter, PoLookupFilteredItemsParams } from '@po-ui/ng-components';
import { Observable, map } from 'rxjs';
import { TotvsResponse } from 'dts-backoffice-util';

@Injectable()
export class GenericsZoomService implements PoLookupFilter {

  private readonly apiUrl = '/dts/datasul-rest/resources/prg/cdp/v1/genericsZoom';

  constructor(private http: HttpClient) {}

  query(
    table: string, 
    fields: string, 
    order: string, 
    filters: PoDisclaimer[] = [], 
    page: number = 1, 
    pageSize: number = 20, 
    other: string = ''
  ): Observable<TotvsResponse<any>> {
    const urlParams = filters.map(filter => `${filter.property}=${filter.value}`).join('&');
    const url = `${this.apiUrl}?pageSize=${pageSize}&page=${page}&table=${table}&fields=${fields}&order=${order}${other}${urlParams ? `&${urlParams}` : ''}`;

    return this.http.get<TotvsResponse<any>>(url);
  }

  getFilteredItems(params: PoLookupFilteredItemsParams): Observable<any> {
    const { filterParams, filter, page, pageSize } = params;
    const localParams = { ...filterParams };

    let url = `${this.apiUrl}?pageSize=${pageSize}&page=${page}&table=${localParams.table}&fields=${localParams.fields}&order=${localParams.order}`;
    if (localParams.filterZoom && filter) {
      url += `&${localParams.filterZoom}=${filter}`;
    }
    if (localParams.other) {
      url += localParams.other;
    }

    return this.http.get(url);
  }

  getObjectByValue(value: string, filterParams?: any): Observable<any> {
    const localParams = { ...filterParams };

    let url = `${this.apiUrl}?table=${localParams.table}&fields=${localParams.fields}&${localParams.filter}=${value}`;
    if (localParams.other) {
      url += localParams.other;
    }

    return this.http.get(url).pipe(
      map((data: any) => data.items[0])
    );
  }
}