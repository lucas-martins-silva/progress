import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TotvsResponse } from 'dts-backoffice-util';

interface RtcResponse {
  lRTC: boolean;
}

@Injectable()
export class RtcService {
  private apiUrl = '/api/ccp/v1/quotationProcess/rtc';

  constructor(private http: HttpClient) {}

  getRtcStatus(): Observable<TotvsResponse<RtcResponse>> {
    let url = this.apiUrl;
    return this.http.get<TotvsResponse<RtcResponse>>(url);
  }
}