import { Component, Input, OnInit, ViewChild, Output, EventEmitter, OnDestroy } from '@angular/core';
import { FormBuilder, FormGroup} from '@angular/forms';
import { PoI18nService, PoLookupColumn, PoModalComponent, PoNotificationService, PoRadioGroupOption, PoTableColumn } from '@po-ui/ng-components';
import { forkJoin, Subscription } from 'rxjs';
import { GenericsZoomService } from 'src/app/shared/services/generics-zoom.service';
import { QuotationService } from 'src/app/shared/services/quotation.service';
import { CurrencyZoomService } from 'src/app/shared/services/currency.service';

@Component({
  selector: 'app-quote-complement-modal',
  templateUrl: './quote-complement-modal.component.html',
  styleUrls: ['./quote-complement-modal.component.css']
})
export class QuoteComplementModalComponent implements OnInit, OnDestroy {
	@ViewChild('mainModal', { static: true }) mainModal: PoModalComponent;
	@Input() quotations = [];
	@Input() vendor = {vendorId: 0, vendorDescription: ''};
	@Output() afterSave: EventEmitter<Event> = new EventEmitter();

	isLoading = false;
	disableSave = true;
	isSpecificCond = false;
	literals: any = {};
	subscription$: Subscription[] = [];
	quotationForm: FormGroup;
	currencyZoomColumns: Array<PoLookupColumn>;
	currencyZoomColumnsReadjust: Array<PoLookupColumn>;
	vendorContactZoomColumns: Array<PoLookupColumn>;
	carrierZoomColumns: Array<PoLookupColumn>;
	paymentTermsZoomColumns: Array<PoLookupColumn>;
	icmsOptions: Array<PoRadioGroupOption>;
	tableColumns: Array<PoTableColumn> = [];
	quotationReajustment = [];
	purchaseParameters = {utilizaTaxa: false, utilizaIcm: false};

	public readonly currencyFilter = {
		fields: 'mo-codigo,descricao',
		filter: 'mo-codigo',
		filterZoom: 'mo-codigo',
		order: 'mo-codigo',
		table: 'mguni.moeda'
	};

	public readonly vendorContactFilter = {
		fields: 'sequencia,nome',
		filter: 'nome',
		filterZoom: 'nome',
		order: 'sequencia',
		table: 'cont-emit',
		other: '&cod-emitente=' + this.vendor.vendorId
	};

	public readonly carrierFilter = {
		fields: 'cod-transp,nome',
		filter: 'cod-transp',
		filterZoom: 'cod-transp',
		order: 'cod-transp',
		table: 'transporte'
	};

	public readonly paymentTermsFilter = {
		fields: 'cod-cond-pag,descricao',
		filter: 'cod-cond-pag',
		filterZoom: 'cod-cond-pag',
		order: 'cod-cond-pag',
		table: 'cond-pagto'
	};

	constructor(
		private poI18nService: PoI18nService,
		private formBuilder: FormBuilder,
		public genericsZoomService: GenericsZoomService,
		private quotationService: QuotationService,
		private poNotification: PoNotificationService,
		public currencyZoomService: CurrencyZoomService) {
			this.quotationForm = this.formBuilder.group({
				validityDays: [{ value: 0, disabled: false }],
				quotationDate: [{ value: new Date(), disabled: false }],
				currency: [{ value: 0, disabled: false }],
				currencyQuotation: [{ value: 0, disabled: false }],
				vendorContact: [{ value: '', disabled: false }],
				carrier: [{ value: 0, disabled: false }],
				deliveryTime: [{ value: 0, disabled: false }],
				freightValue: [{ value: 0, disabled: false }],
				freightIncluded: [{ value: false, disabled: false }],
				paymentTerms: [{ value: 0, disabled: false }],
				specificPaymentTerms: [{ value: false, disabled:false }],
				financialRate: [{ value: false, disabled: true }],
				finTaxValue: [{ value: 0, disabled: false }],
				financialRateDays: [{ value: 0, disabled: false }],
				ipiIncluded: [{ value: false, disabled: false }],
				icmsType: [{ value: 2, disabled: true }],
				readjustQuotation: [{ value: false, disabled: false }],
				priceBaseDate: [{ value: new Date(), disabled: false }],
			});
		}

	ngOnInit(): void {		
		this.subscription$.push(forkJoin([this.poI18nService.getLiterals()])
			.subscribe(literals => literals.map(item => Object.assign(this.literals, item)))
		);
	
		this.getPurchaseParameters();
		
		this.currencyZoomColumns = [
			{ property: 'moCodigo', label: this.literals['code'] },
			{ property: 'descricao', label: this.literals['description'] }
		];

		this.currencyZoomColumnsReadjust = [
			{ property: 'currencyCode', label: this.literals['code'] },
			{ property: 'currencyDescription', label: this.literals['description'] }
		];

		this.vendorContactZoomColumns = [
			{ property: 'sequencia', label: this.literals['code'] },
			{ property: 'nome', label: this.literals['description'] }
		];

		this.carrierZoomColumns = [
			{ property: 'codTransp', label: this.literals['code'] },
			{ property: 'nome', label: this.literals['description'] }
		];

		this.paymentTermsZoomColumns = [
			{ property: 'codCondPag', label: this.literals['code'] },
			{ property: 'descricao', label: this.literals['description'] }
		];

		this.icmsOptions= [
			{ label: this.literals['consumption'], value: 2 },
			{ label: this.literals['industrialization'], value: 1 }
		];

		this.tableColumns = [
			{ property: 'currency', label: this.literals['currency'], type: 'cellTemplate'},
			{ property: 'indexDate', label: this.literals['dataBase'], type: 'cellTemplate',},
			{ property: 'percReadjustment', label: this.literals['percReadjustment'], type: 'cellTemplate'},
			{ property: 'remove', type: 'icon', label: ' ',
			icons: [
					{
						action: this.remove.bind(this),
						color: 'color-07',
						icon: 'po-icon po-icon-delete',
						tooltip: this.literals['remove'],
						value: 'remove',
					}
				]
			},
		];
	}

	openModal(): void {
		this.vendorContactFilter.other = '&cod-emitente=' + this.vendor.vendorId;
		this.mainModal.open();
		this.fillFields();
	}

	closeModal() {
		this.mainModal.close();
	}

	ngOnDestroy(): void {	
		if (this.subscription$ !== undefined) {
			this.subscription$.forEach((sub: Subscription) => sub.unsubscribe());
		}
	}

	fieldCurrencyFormat(value) {
		return `${value.moCodigo} - ${value.descricao} `;
	}
	fieldCurrencyFormatReadjust(value) {
		return `${value.currencyCode} - ${value.currencyDescription} `;
	}

	fieldVendorContactFormat(value) {
		return `${value.nome} `;
	}

	fieldCarrierFormat(value) {
		return `${value.codTransp} - ${value.nome} `;
	}

	paymentTermsFormat(value) {
		return `${value.codCondPag} - ${value.descricao} `;
	}

	changeCurrency(field) {
		const body = {
			'action': 'update',
			'property': field,
			'quotation': this.quotations[0]
		}
		body.quotation.currency = Number(this.quotationForm.controls['currency'].value);
		body.quotation.quotationDate = this.quotationForm.controls['quotationDate'].value;

		this.subscription$.push(this.quotationService.setDefaults(body).subscribe({
			next: (response) => {
				this.quotationForm.controls['currencyQuotation'].setValue(response['quotation']['currencyQuotation']);
				this.disableSave = false;
			},
			error: error => {
				this.disableSave = false;
				throw new Error(error);
			}
		}));
	}

	getPurchaseParameters() {
		this.subscription$.push(this.genericsZoomService.query('param-compra', 'utiliza-taxa,utiliza-icm', '').subscribe({
			next: (response) => {
				this.purchaseParameters = response.items[0];
			},
			error: error => {
				throw new Error(error);
			}
		}));
	}

	add() {
		if (this.quotationReajustment.length == 5) {
			this.poNotification.error(this.literals['errorAddQuotationReajustment']);
			return;
		} 

		this.quotationReajustment.push(
			{
				sequence: this.quotationReajustment.length + 1,
				currency: 0,
				indexDate: this.quotationForm.controls['priceBaseDate'].value,
				percReadjustment: 0,
				remove: ['remove']
			}
		)

		this.percentageAdjustment()
	}

	remove(value) {
		let cont = 0;
		this.quotationReajustment.splice(value.sequence - 1, 1);

		for (const quotation of this.quotationReajustment) {
			cont++
			quotation.sequence = cont;
		}

		this.percentageAdjustment();
	}

	percentageAdjustment() {		
		let percentValue = 0;

		percentValue = 100 / this.quotationReajustment.length;

		for (const reajustment of this.quotationReajustment) {
			reajustment.percReadjustment = Math.trunc(percentValue);
		}
		
		this.quotationReajustment[0].percReadjustment = this.quotationReajustment[0].percReadjustment + (100 - (Math.trunc(percentValue) * this.quotationReajustment.length));
	}

	specificPaymentTerms(item: boolean) {
		if (item) this.quotationForm.controls['paymentTerms'].setValue(0);
		
		this.isSpecificCond = item;		
	}
	
	fillFields() {
		this.disableSave = true;

		const body = {
			'action': 'update',
			'property': '',
			'quotation': this.quotations[0]
		}
		this.subscription$.push(this.quotationService.setDefaults(body).subscribe({
			next: (response) => {
					//Cotacao
				    this.quotationForm.controls['validityDays'].setValue(response['quotation']['validityDays']); 
					this.quotationForm.controls['quotationDate'].setValue(response['quotation']['quotationDate']);
					if (response['quotation']['currency'] == 0){
						this.quotationForm.controls['currency'].setValue('0');	
					} else {
						this.quotationForm.controls['currency'].setValue(response['quotation']['currency']);
					}
					
					this.quotationForm.controls['currencyQuotation'].setValue(response['quotation']['currencyQuotation']);
					this.quotationForm.controls['vendorContact'].setValue(response['quotation']['vendorContact']);
					
					// Frete
					if (response['quotation']['carrier'] == 0){
						this.quotationForm.controls['carrier'].setValue('0');		
					} else {
						this.quotationForm.controls['carrier'].setValue(response['quotation']['carrier']);
					}
					this.quotationForm.controls['deliveryTime'].setValue(response['quotation']['deliveryTime']);
					this.quotationForm.controls['freightValue'].setValue(response['quotation']['freightValue']);
					// switch
					this.quotationForm.controls['freightIncluded'].setValue(response['quotation']['freightIncluded']);
					
					//Financeiro/Fiscal
					if (response['quotation']['paymentTerms'] == 0){
						this.quotationForm.controls['paymentTerms'].setValue(0);
						this.quotationForm.controls['specificPaymentTerms'].setValue(true);
						this.isSpecificCond = true;
					} else {
						this.quotationForm.controls['paymentTerms'].setValue(response['quotation']['paymentTerms']);
						this.quotationForm.controls['specificPaymentTerms'].setValue(false);
						this.isSpecificCond = false;
					}
					// switch
					this.quotationForm.controls['financialRate'].setValue(response['quotation']['financialRate']);
					this.quotationForm.controls['finTaxValue'].setValue(response['quotation']['finTaxValue']);
					this.quotationForm.controls['financialRateDays'].setValue(response['quotation']['financialRateDays']);
					// switch
					this.quotationForm.controls['ipiIncluded'].setValue(response['quotation']['ipiIncluded']);
					this.quotationForm.controls['icmsType'].setValue(response['quotation']['icmsType']);
					
					// Reajute
					this.quotationForm.controls['readjustQuotation'].setValue(response['quotation']['readjustQuotation']);
					
					if (this.quotationReajustment.length > 0)
						this.quotationReajustment = [];
			},
			error: error => {
					throw new Error(error);
			}
		}));
	}

	async save() {

		this.closeModal();

		this.isLoading = true;

		await this.saveQuotationReajust().then(result => {
			this.saveQuotation().then(data => {
				this.isLoading = false;
			}).catch(error => {
				this.isLoading = false;
			});
		}).catch(error => {
			this.isLoading = false;
		});;
		
	}

	async saveQuotationReajust() {		

		let countRequisitonReturn = 0;	

		return new Promise((resolve, reject) => {

			if (this.quotationForm.controls['readjustQuotation'].value) {

				for (const quotation of this.quotations) {

					for (const quotationReajust of this.quotationReajustment) {
						quotationReajust.priceBaseDate = this.quotationForm.controls['priceBaseDate'].value;
						quotationReajust.quotationDate = quotation.quotationDate;
						quotationReajust.purchaseRequisition = quotation.purchaseRequisition;
						quotationReajust.vendor = quotation.vendor;
						quotationReajust.item = quotation.item;
						quotationReajust.currency = Number(quotationReajust.currency);
					}

					let body = {				
						'quotationsReadjustment': this.quotationReajustment
					}

					this.subscription$.push(this.quotationService.quotationsReadjustment(body).subscribe({
						next: (response) => {
							countRequisitonReturn++;

							if (countRequisitonReturn == this.quotations.length) {
								resolve(true);
							}
						},
						error: error => {
							reject();
							throw new Error(error);
						}
					}));
				}
			} else {
				resolve(true);
			}
		});
	}

	saveQuotation() {
		let countRequisitonReturn = 0;
		let countRequisitonReturnError = 0;

		return new Promise((resolve, reject) => {
			for (const quotation of this.quotations) {
				const body = {
					'action': 'update',
					'property': '',
					'quotation': quotation
				}				
			
				this.subscription$.push(this.quotationService.setDefaults(body).subscribe({
					next: (response) => {
						quotation.seqQuotation = response['quotation']['seqQuotation'];
						quotation.validityDays = this.quotationForm.controls['validityDays'].value;
						quotation.quotationDate = this.quotationForm.controls['quotationDate'].value;
						quotation.currency = this.quotationForm.controls['currency'].value;
						quotation.currencyQuotation = this.quotationForm.controls['currencyQuotation'].value;
						quotation.vendorContact = this.quotationForm.controls['vendorContact'].value;
						quotation.carrier = this.quotationForm.controls['carrier'].value;
						quotation.deliveryTime = this.quotationForm.controls['deliveryTime'].value;
						quotation.freightValue = this.quotationForm.controls['freightValue'].value;
						quotation.freightIncluded = this.quotationForm.controls['freightIncluded'].value;
						quotation.paymentTerms = this.quotationForm.controls['paymentTerms'].value;
						quotation.financialRate = this.quotationForm.controls['financialRate'].value;
						quotation.finTaxValue = this.quotationForm.controls['finTaxValue'].value;
						quotation.financialRateDays = this.quotationForm.controls['financialRateDays'].value;
						quotation.ipiIncluded = this.quotationForm.controls['ipiIncluded'].value;
						quotation.icmsType = this.quotationForm.controls['icmsType'].value;
						quotation.readjustQuotation = this.quotationForm.controls['readjustQuotation'].value;						
						quotation.readjustment = this.quotationForm.controls['readjustQuotation'].value;						

						this.subscription$.push(this.quotationService.saveQuotations(quotation).subscribe({
							next: (response) => {
								countRequisitonReturn++;				

								if (countRequisitonReturn == (this.quotations.length - countRequisitonReturnError)) {
									this.afterSave.emit();
									resolve(true);
								}
							},
							error: error => {
								countRequisitonReturnError++

								if (countRequisitonReturnError == this.quotations.length) {
									this.afterSave.emit();
									reject();
								}

								throw new Error(error);
							}
						}));

					},
					error: error => {
						reject();
						throw new Error(error);
					}
				}));
			}
		});

	}
}
