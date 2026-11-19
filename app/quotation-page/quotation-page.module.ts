import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { PoI18nPipe, PoModule } from '@po-ui/ng-components';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { QuotationPageComponent } from './quotation-page.component';
import { QuotationService } from 'src/app/shared/services/quotation.service';
import { FilterSimpleAndAdvancedService } from 'src/app/shared/services/filter-simple-and-advanced.service';
import { QuotationPageRoutingModule } from './quotation-page-routing.module';
import { QuoteComplementModalModule } from '../shared/components/quote-complement/quote-complement-modal.module';
import { itemManufacturesZoomService } from 'src/app/shared/services/item-manufactures-zoom.service';
import { UNZoomService } from 'src/app/shared/services/un-zoom.service';
import { QuotationProcessZoomService } from 'src/app/shared/services/quotation-process-zoom.service';
import { VendorZoomService } from 'src/app/shared/services/vendor-zoom.service';
import { MenuDatasulService } from 'dts-backoffice-util';
import { LastPurchaseService } from '../shared/services/last-purchase.service';
import { RtcService } from '../shared/services/rtc.service';


@NgModule({
	declarations: [
		QuotationPageComponent, 
	],
	imports: [
		CommonModule,
		PoModule,
		QuotationPageRoutingModule,
		ReactiveFormsModule,
		HttpClientModule,
		FormsModule,
		QuoteComplementModalModule
	],
	providers: [
		PoI18nPipe,
		QuotationService,
		FilterSimpleAndAdvancedService,
		itemManufacturesZoomService,
		UNZoomService,
		QuotationProcessZoomService,
		VendorZoomService,
		MenuDatasulService,
		LastPurchaseService,
		RtcService
	]
})
export class QuotationPageModule { }
