import { Component, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { forkJoin, Subscription } from 'rxjs';
import {
  PoI18nService,
  PoPageFilter,
  PoPageAction,
  PoTableColumn,
  PoTableColumnLabel,
  PoModalAction,
  PoLookupColumn,
  PoNotificationService,
  PoTableAction,
  PoDialogService,
  PoDynamicViewField,
  PoPageListComponent
} from '@po-ui/ng-components';
import { FormBuilder, FormGroup } from '@angular/forms';
import { QuotationService } from 'src/app/shared/services/quotation.service';
import { FilterSimpleAndAdvancedService } from 'src/app/shared/services/filter-simple-and-advanced.service';
import { UNZoomService } from 'src/app/shared/services/un-zoom.service';
import { itemManufacturesZoomService } from 'src/app/shared/services/item-manufactures-zoom.service';
import { QuotationProcessZoomService } from 'src/app/shared/services/quotation-process-zoom.service';
import { VendorZoomService } from 'src/app/shared/services/vendor-zoom.service';
import { MessageService } from '@totvs-frame-datasul/dts-fnd-utils';
import { MenuDatasulService } from 'dts-backoffice-util';
import { LastPurchase } from 'src/app/shared/models/last-purchase.model';
import { LastPurchaseService } from 'src/app/shared/services/last-purchase.service';
import { RtcService } from 'src/app/shared/services/rtc.service';

@Component({
  selector: 'app-quotation-page',
  templateUrl: './quotation-page.component.html',
  styleUrls: ['./quotation-page.component.css']
})
export class QuotationPageComponent implements OnInit, OnDestroy {
  @ViewChild('advancedFilterModal', { static: true }) advancedFilterModal: any;
  @ViewChild('poPageList', { static: true }) poPageList: PoPageListComponent;
  @ViewChild('modalQuoteComplement', { static: true }) modalQuoteComplement: any;

  literals: any = {};
  filterSettings: PoPageFilter;
  hiddenList: boolean;
  disclaimers: Array<any> = [];
  disclaimerGroup: any;
  actions: Array<PoPageAction> = [];
  tableQuotationsColumns: Array<PoTableColumn> = [];
  tableLastPurchasesColumns: Array<PoTableColumn> = [];
  adictionalsValuesViewFild: Array<PoDynamicViewField> = [];
  adictionalsValues: { itemDescription: string, additionalInformation: string };
  tableActions: Array<PoTableAction> = []
  quotations = [];
  lastPurchase: { vendor: LastPurchase[], item: LastPurchase[] } = { vendor: [], item:[] } 
  quotationsIsLoading = false;
  lastPurchaseIsLoading = false;
  currentPage = 0;
  pageSize = 20;
  subscription$: Subscription[] = [];
  lastPurchaseSubscription$: Subscription[] = [];
  orderSituationLabels: Array<PoTableColumnLabel> = [];
  advancedFilterPrimaryAction: PoModalAction;
  advancedFilterForm: FormGroup;
  filterFormated: string = '';
  simpleFilter: string = 'search';
  quoteCodeForTheSelectedRow = '';
  oldQuoteCodeForTheSelectedRow = ''
  columnsUnZoom: Array<PoLookupColumn>;
  columnsItemManufacturers: Array<PoLookupColumn>;
  columnsQuotationProcess: Array<PoLookupColumn>;
  columnsVendor: Array<PoLookupColumn>;
  disableSave = true;
  quotationProcessId: number = 0;
  quotationProcessLabel: string = '';
  vendorId: number = 0;
  vendorLabel: string = '';
  disclaimersFixed: Array<any> = [];
  quotationsToSave = [];
  contChangeQuotationProcessIdZoom = 0;
  lOpenedView = false;
  lRTC = false;
  rtcActions: Array<PoPageAction> = [];

   // Dados temporários usados pelos campos da aba Tributos RTC
  rtcTaxes = {
    cbs: {
      tributacao: '',
      baseCalculo: 0,
      aliquota: 0,
      reducaoAliquota: 0,
      aliquotaEfetiva: 0,
      valor: 0
    },
    ibsUf: {
      tributacao: '',
      baseCalculo: 0,
      aliquota: 0,
      reducaoAliquota: 0,
      aliquotaEfetiva: 0,
      valor: 0
    },
    ibsMun: {
      tributacao: '',
      baseCalculo: 0,
      aliquota: 0,
      reducaoAliquota: 0,
      aliquotaEfetiva: 0,
      valor: 0
    },
    is: {
      tributacao: '',
      aliquota: 0,
      aliqEspecUn: 0,
      qtdeTributavel: 0,
      unTributavel: '',
      baseCalculo: 0,
      valor: 0
    }
  };

  constructor(
    private poI18nService: PoI18nService,
    private quotationService: QuotationService,
    private formBuilder: FormBuilder,
    private filterSimpleAndAdvancedService: FilterSimpleAndAdvancedService,
    public UNZoomService: UNZoomService,
    public itemManufacturesZoomService: itemManufacturesZoomService,
    public quotationProcessZoomService: QuotationProcessZoomService,
    public vendorZoomService: VendorZoomService,
    private poNotification: PoNotificationService,
    private poDialog: PoDialogService,
    private messageService: MessageService,
    private menuDatasulService: MenuDatasulService,
    private lastPurchaseService: LastPurchaseService,
    private rtcService: RtcService,
  ) {
    this.advancedFilterForm = this.formBuilder.group({
      quotationProcessId: [{ value: '', disabled: false }],
      quotationProcessLabel: [{ value: '', disabled: false }],
      vendorId: [{ value: '', disabled: false }],
      vendorLabel: [{ value: '', disabled: false }],
      onlyWithoutQuotation: [{ value: false, disabled: false }],
    });

    this.messageService.on('alreadyOpen', this.alreadyOpen.bind(this));
  }

  ngOnInit(): void {
    this.initialize();    
  }

  private alreadyOpen(event: any){
    this.lOpenedView = true;

    if (this.quotationProcessId != Number(localStorage.getItem('quotationProcessId'))
    ||  this.vendorId != Number(localStorage.getItem('vendorId'))) {
      this.initialize();
    }
  }

  initialize() {
    this.quotationProcessId = Number(localStorage.getItem('quotationProcessId'));
    this.quotationProcessLabel = localStorage.getItem('quotationProcessLabel');
    this.vendorId = Number(localStorage.getItem('vendorId'));
    this.vendorLabel = localStorage.getItem('vendorLabel');

    this.hiddenList = false;

    this.subscription$.push(forkJoin([this.poI18nService.getLiterals()]).subscribe(literals => {
      literals.map(item => Object.assign(this.literals, item));

      this.rtcService.getRtcStatus().subscribe({
        next: response => {
          this.lRTC = Boolean(response?.items?.[0]?.lRTC);
        },
        error: error => {
          this.lRTC = false;
          console.error('Falha ao consultar a flag RTC', error);
        }
      });
      this.setupComponents();
      this.vendorsOfProcess();
    }));
  }

  setupComponents(): void {
    this.orderSituationLabels = [
      { value: 1, color: 'color-08', label: this.literals['notConfirmed'], textColor: 'white' },
      { value: 2, color: 'color-10', label: this.literals['confirmed'], textColor: 'white' },
      { value: 3, color: 'color-01', label: this.literals['quoted'], textColor: 'white' },
      { value: 4, color: 'color-07', label: this.literals['deleted'], textColor: 'white' },
      { value: 5, color: 'color-09', label: this.literals['inQuotation'], textColor: 'white' },
      { value: 6, color: 'color-12', label: this.literals['received'], textColor: 'white' },
    ];

    this.actions = [
      { label: this.literals['save'], action: this.save.bind(this), disabled: this.disableSaveButton.bind(this) },
      { label: this.literals['analyzeQuotes'], action: this.analyzeQuotes.bind(this) },
    ];

    this.filterSettings = {
      action: this.filterAction.bind(this),
      advancedAction: this.advancedFilterActionModal.bind(this),
      placeholder: this.literals['placeholderSearchQuotation'],
    };

    this.disclaimerGroup = {
      title: this.literals['filters'],
      disclaimers: [],
      change: this.onChangeDisclaimer.bind(this),
      remove: this.onClearDisclaimer.bind(this),
      removeAll: this.onClearAllDisclaimers.bind(this)
    };
    this.adictionalsValuesViewFild =[
      { property: 'itemDescription', label:  this.literals['itemDescription'], type: 'string',gridColumns: 12 },
      { property: 'additionalInformation', label: this.literals['additionalInformation'], type: 'string' },
    ]
    this.tableQuotationsColumns = [
      { width: "10%", property: 'purchaseRequisition', label: this.literals['order'], type: 'string'},
      { width: "8%",property: 'item', label: this.literals['itemCode'], type: 'string' },
      { width: "6%",property: 'internalUM', label: this.literals['umItem'], type: 'string' },
      { width: "7%",property: 'qtyRequested', label: this.literals['qtRequested'], type: 'number', format: '1.4-4' },      
      { width: "9%",property: 'unitOfMeasure', label: this.literals['UM'], type: 'cellTemplate' },
      { width: "9%",property: 'vendorPrice', label: this.literals['supplierPrice'], type: 'cellTemplate' },
      { width: "7%",property: 'ipiPercent', label: this.literals['ipiTaxRate'], type: 'cellTemplate' },
      { width: "7%",property: 'icmsPercent', label: this.literals['icmsTaxRate'], type: 'cellTemplate' },
      { width: "7%",property: 'discountPerc', label: this.literals['discount'], type: 'cellTemplate' },
      { width: "7%",property: 'finTaxValue', label: this.literals['finalFeeValue'], type: 'cellTemplate' },
      { width: "5%",property: 'manufacturer', label: this.literals['manufacturer'], type: 'cellTemplate' },
      { width: "7%",property: 'vendorUnitPrice', label: this.literals['finalUnitPrice'], type: 'number', format: '1.4-4' },
      ...(this.lRTC ?
        [{ width: "7%", property: 'rtcPrice', label: this.literals['rtcPrice'], type: 'number', format: '1.4-4' }] : []
      ),
      { width:"120px", property: 'status', label: this.literals['situation'], type: 'label', labels: this.orderSituationLabels },
    ];

    this.tableLastPurchasesColumns = [
      { property: 'unityPriceFormated', label:this.literals['unitPrice'],type: 'number', width: "6%"},
      { property: 'unitsOfMeasureFormated', label:this.literals['unitOfMeasurement'],type: 'string', width: "10%"},
      { property: 'purchaseDate', label:this.literals['date'], type: 'date', width: "12%"},
      { property: 'paymentCondition', label:this.literals['paymentCondition'],type: 'string', width: "21%"},
      { property: 'purchaseRequisitionId', label:this.literals['purchaserequest'],type: 'string', width: "12%"},
      { property: 'supplierId', label:this.literals['supplier'], type: 'string', width: "10%"},
      { property: 'supplierDescription', label:this.literals['supplierName'],type: 'string', width: "17%"},
      { property: 'supplierCNPJ', label:this.literals['cnpjCpf'], type: 'string', width: "18%"}
    ]

    this.tableActions = [
      {
        action: this.duplicateQuotation.bind(this),
        icon: 'po-icon po-icon-copy',
        label: this.literals['duplicate'],
        disabled: this.validateDisableDuplicate.bind(this),
        visible: this.validateDisableDuplicate.bind(this),
      },
      { 
        action: this.removeQuotation.bind(this), 
        icon: 'po-icon po-icon-delete', 
        label: this.literals['remove'],
        disabled: this.validateDisableDelete.bind(this)
      },
    ];

    this.columnsUnZoom = [
      { property: 'unitOfMeasure', label: this.literals['code'] },
      { property: 'unitOfMeasureDescription', label: this.literals['description'] }
    ];

    this.columnsItemManufacturers = [
      { property: 'manufacturerCode', label: this.literals['code'] },
      { property: 'manufacturerDescription', label: this.literals['description'] }
    ];

    this.columnsQuotationProcess = [
      { property: 'quotationProcessNumber', label: this.literals['code'] },
      { property: 'description', label: this.literals['description'] }
    ];

    this.columnsVendor = [
      { property: 'vendorId', label: this.literals['code'] },
      { property: 'name', label: this.literals['description'] }
    ];

    this.rtcActions = [
      {
        label: this.literals['calculateTaxes'],
        action: this.calculateTaxes.bind(this)
      }
    ];
  }
  public poPageListHeight(percent: number): string {
    let TotalPageListHeight: string = this.poPageList.poPageContent.height;
    let TotalPageListHeightLenght: number = this.poPageList.poPageContent.height.length;
    let isPx: Boolean = TotalPageListHeight.substring(TotalPageListHeightLenght-2, TotalPageListHeightLenght) == "px"
    TotalPageListHeight = TotalPageListHeight.substring(0, TotalPageListHeight.length - 2) 
    
    if( !isPx ){
      return "300"
    }
    TotalPageListHeight = String((percent / 100) * +TotalPageListHeight);
    return TotalPageListHeight;
  }

  public disableSaveButton(): boolean{
    return this.disableSave;
  }

  parseTagToDisclaimers(tag: any, value: number): void {
    let i: number, _self = this;

    for (i = 0; i < this.disclaimers.length; i++) {
      if (this.disclaimers[i].property === tag.property) {
        this.disclaimers.splice(i, 1);
        break;
      }
    };

    this.parseDisclaimersGroup();
  }

  onChangeDisclaimer(disclaimers: any): void {
    this.disclaimers = disclaimers;
    this.filter();
    
    // Quando reabre a tela, dispara o onChangeDisclaimer, essa validação é pra não executar o search pois ainda não buscou os dados do Vendor
    if (!this.lOpenedView) {      
      this.searchQuotation();
    } 
    this.lOpenedView = false;    
  }

  onClearDisclaimer(disclaimers: any): void {
    
    let simpleFilter: any = undefined;

    //se restou algum disclaimer
    if (disclaimers && disclaimers.currentDisclaimers && disclaimers.currentDisclaimers.length > 0) {
      simpleFilter = disclaimers.currentDisclaimers.find(element => element.property == this.simpleFilter);
    }

    if (disclaimers.removedDisclaimer.property === 'onlyWithoutQuotation') {      
      this.advancedFilterForm.controls['onlyWithoutQuotation'].setValue('');
    }

    this.filterAction('');

  }

  onClearAllDisclaimers(): void {
    this.applyAdvancedFilter();
  }

  filterAction(labelFilter: any | Array<string>, advancedFilter?): void {
    const filter = typeof labelFilter === 'string' ? [labelFilter] : [...labelFilter];

    if (!advancedFilter) {
      this.advancedFilterForm.reset();
    }

    this.populateDisclaimers(filter, advancedFilter);
    this.filter();
  }

  advancedFilterActionModal(): void {
    this.advancedFilterForm.controls['quotationProcessId'].setValue(this.quotationProcessId);
    this.advancedFilterForm.controls['vendorId'].setValue(this.vendorId);

    this.advancedFilterModal.open();
  }

  populateDisclaimers(filters: Array<any>, advancedFilter?): void {

    this.filterFormated = '';

    if (filters.length === 1 && filters[0] !== '' && !filters[0].hasOwnProperty('property')) {
      this.disclaimers = filters.map((value) => ({ value: value, filter: value, property: this.simpleFilter }));
      this.filterFormated = this.filterSimpleAndAdvancedService.equals(this.simpleFilter, filters[0]);
    } else if (advancedFilter && filters.length > 0) {
      for (let i = 0; i < filters.length; i++) {        
        if (filters[i].property === 'onlyWithoutQuotation') {          
          this.filterFormated = 'onlyWithoutQuotation=true';
        }
      }

      this.disclaimers = [];
      filters.forEach((value) => {
        this.disclaimers.push(
          { value: value.label + ': ' + value.value, property: value.property + value.determinant }
        );        
      });
    } else if (filters.length === 1 && filters[0] === '') {
      const indice = this.disclaimers.findIndex(disclaimer => disclaimer.property == 'simpleFilter');
      if (indice != -1) {
        this.disclaimers.splice(indice, 1);
      }
      this.disclaimers = [];
      this.searchQuotation();
    } else {
      this.disclaimers = [];
    }

    this.parseDisclaimersGroup();

  }

  parseDisclaimersGroup(): void {

    this.disclaimersFixed = [];

    this.disclaimersFixed.push({
      value: `${this.literals['quotationProcess']}: ${this.quotationProcessId + ' - ' + this.quotationProcessLabel}`,
      property: this.quotationProcessId,
      hideClose: true
    });

    if (this.vendorId) {
      this.disclaimersFixed.push({
        value: `${this.literals['supplier']}: ${this.vendorId + ' - ' + this.vendorLabel}`,
        property: this.vendorId,
        hideClose: true
      });
    }

    this.disclaimerGroup.disclaimers = [];

    if (this.disclaimers && this.disclaimers.length > 0) {
      this.disclaimerGroup.disclaimers = [...this.disclaimersFixed, ...this.disclaimers];
    } else {
      this.disclaimerGroup.disclaimers = this.disclaimersFixed;
    }
  }

  filter(): void {
    const filters = this.disclaimers.map((disclaimer: any) => disclaimer.property);

    if (filters.length === 0) {
      this.poPageList.clearInputSearch();
    }
  }

  vendorsOfProcess(): void {

    this.quotationsIsLoading = true;
    this.subscription$.push(this.quotationService.getVendorsOfProcess(this.quotationProcessId).subscribe({
      next: (response) => {
        
        const vendorsOfProcess = response.items;

        // A flag global vem repetida nos registros de vendor.
        this.lRTC = vendorsOfProcess.length > 0
          ? Boolean(vendorsOfProcess[0].lRTC)
          : false;

        if (this.vendorId) {
          const searchVendorOfList = vendorsOfProcess.find(element => element.vendorId == this.vendorId);

          if (!searchVendorOfList) {

            const message =  this.literals['erroMessageVendor'].replace('X', this.vendorId).replace('Y', this.quotationProcessId);

            this.poNotification.error(message);
            this.quotationsIsLoading = false;
            return;
          }
        } else {
          if (vendorsOfProcess && vendorsOfProcess.length > 0) {
            this.vendorId = vendorsOfProcess[0].vendorId;
            this.vendorLabel = vendorsOfProcess[0].shortName;
          }
        }

        this.parseDisclaimersGroup();
        
      },
      error: error => {
        this.quotationsIsLoading = false;
        throw new Error(error);
      }
    }));
  }

  searchQuotation(loadMore = false): void {  

    this.quotationsIsLoading = true;
    this.disableSave = true;

    if (loadMore === true) {
      this.currentPage = this.currentPage + 1;
    } else {
      this.quotations = [];
      this.currentPage = 1;
    }
    this.subscription$.push(this.quotationService.getQuotationProcess(
        (this.filterFormated),
        this.quotationProcessId,
        this.vendorId
      ).subscribe({
        next: (response) => {
          this.quotations = response.items;

          if (this.quotations && this.quotations.length > 0) {
            
            this.tableQuotationsColumns = this.tableQuotationsColumns.map(item => {
              if (item.property === 'manufacturer') 
                return {...item, visible: this.quotations[0].activeHisFunction}
              else
                return {...item}
            });
          }

          if (this.quotations.find(quotation => quotation.status == 1 || quotation.status == 5)) {
            this.disableSave = false;
          }

          this.quoteCodeForTheSelectedRow = '';

        },
        error: error => {
          throw new Error(error);
        },
        complete: ( ) => {
          this.quotationsIsLoading = false
        }
    }));
  }
  private addLastPurchase( itemName: string, orderId: string, supplierUnity: string, supplierId: string ): void {
    if(this.oldQuoteCodeForTheSelectedRow === this.quoteCodeForTheSelectedRow){
      return;
    }

    this.oldQuoteCodeForTheSelectedRow = this.quoteCodeForTheSelectedRow;
    
    this.lastPurchaseSubscription$.map( row => row.unsubscribe( ) );

    this.lastPurchase.vendor = [];
    this.lastPurchase.item = [];

    this.lastPurchaseIsLoading = true;
    this.lastPurchaseSubscription$.push(
      this.lastPurchaseService.getLastPurchase( itemName, orderId, supplierUnity, supplierId ).subscribe( {
        next: requestResult => {
          requestResult.items.map( 
            row => {
              if( row.typeLastPurchase === "vendor" ){
                this.lastPurchase.vendor.push( new LastPurchase( row ) );
              }else if( row => row.typeLastPurchase === "item" ){
                this.lastPurchase.item.push( new LastPurchase( row ) )
              }
            } 
          )
          this.lastPurchase.vendor.map( row => row.autoFormat() )
          this.lastPurchase.item.map( row => row.autoFormat() )
        },
        error: error => {
          throw new Error(error);
        },
        complete: ( ) => {
          this.lastPurchaseIsLoading = false;
        }
      })
    )
  }
  ngOnDestroy(): void {
    if (this.subscription$ !== undefined) {
      this.subscription$.forEach((sub: Subscription) => sub.unsubscribe());
    }
  }

  async applyAdvancedFilter() {
    const filters = [];
    if (!this.advancedFilterForm.valid) {
      return;
    }
    
    this.lastPurchase = {item:[], vendor:[]}

    this.quotationProcessId = this.advancedFilterForm.controls['quotationProcessId'].value;
    this.quotationProcessLabel = this.advancedFilterForm.controls['quotationProcessLabel'].value;
    this.vendorId = this.advancedFilterForm.controls['vendorId'].value;
    this.vendorLabel = this.advancedFilterForm.controls['vendorLabel'].value;

    if (
      this.advancedFilterForm.controls['onlyWithoutQuotation'].value !== null &&
      this.advancedFilterForm.controls['onlyWithoutQuotation'].value !== '' &&
      this.advancedFilterForm.controls['onlyWithoutQuotation'].value === true
    ) {
      filters.push({
        value: this.advancedFilterForm.controls['onlyWithoutQuotation'].value,
        property: 'onlyWithoutQuotation',
        determinant: '',
        label: this.literals['onlyWithoutQuotation']
      });
    }

    this.filterAction(filters, true);

    if (!this.advancedFilterModal.hidden || this.advancedFilterModal.hidden === false)
      this.advancedFilterModal.close();
  }

  private save() {

    if (this.quotationsToSave.length > 0) {
      this.quotationsToSave = [];
    }

    for (const quotation of this.quotations) {

      if (quotation.status == 1 || quotation.status == 5) {
        this.quotationsToSave.push(quotation);
      }
    }

    this.modalQuoteComplement.quotations = this.quotationsToSave;
    this.modalQuoteComplement.openModal();
  }

  private calculateTaxes(): void {
    // Implementar o comportamento do botão posteriormente.
  }

  private analyzeQuotes() {
    const paramters = {
      processNumber: this.quotationProcessId.toString(),
      pending: false,
      quoted: true,
      confirmed: true,
      received: true,
      deleted: true,
      approved: true,
      quotationDateIn: new Date(0).getTime()
    };
    localStorage.setItem('mccQuoteParams', JSON.stringify(paramters));
    
    this.menuDatasulService.openTHF('dts/mcc/quotation', '', true);
  }

  rowSelected(row) {
    this.quoteCodeForTheSelectedRow = `${row.purchaseRequisition}|${row.vendor}|${row.item}|${row.seqQuotation}`;
    this.adictionalsValues = { itemDescription: row.itemDescription, additionalInformation: row.additionalInformation }
    this.addLastPurchase(row.item, row.purchaseRequisition, row.unitOfMeasure, this.vendorId.toString());
  }

  checkRow(row, isDetail?) {

    if (!isDetail && this.quoteCodeForTheSelectedRow == `${row.purchaseRequisition}|${row.vendor}|${row.item}|${row.seqQuotation}`)
      return true;
    else if (isDetail && this.quoteCodeForTheSelectedRow != `${row.purchaseRequisition}|${row.vendor}|${row.item}|${row.seqQuotation}`)
      return true;
    else
      return false;
  }

  fieldUnFormat(value): string {
    return `${value.unitOfMeasure} - ${value.unitOfMeasureDescription} `;
  }

  fieldQuotationProcessIdFormat(value): string {
    return `${value.quotationProcessNumber} - ${value.description} `;
  }

  fieldVendorIdFormat(value): string {
    return `${value.vendorId} - ${value.name} `;
  }

  calculeteVendorUnitPrice(field, quotation) {

    const body = {
      'action': 'update',
      'property': field,
      'quotation': quotation
    }

    this.subscription$.push(this.quotationService.setDefaults(body).subscribe({
      next: (response) => {

        this.quotations.find((quotation) => {
          if (quotation.purchaseRequisition == response['quotation']['purchaseRequisition']) {
            quotation.vendorUnitPrice = response['quotation']['vendorUnitPrice'];
            if (field === 'discountPerc') {
              quotation.discountValue = quotation.vendorPrice * (quotation.discountPerc/ 100);
            }
          }
        });        
      },
      error: error => {
        throw new Error(error);
      }
    }));
  }

  changeLabelParams(value, field) {

    if (field == 'quotationProcessId') {
      this.advancedFilterForm.controls['quotationProcessLabel'].setValue(value.description);
    }

    if (field === 'vendorId') {
      this.advancedFilterForm.controls['vendorLabel'].setValue(value.name);
    }
  }

  changeQuotationProcessIdZoom() {

    if (this.contChangeQuotationProcessIdZoom > 0) {
      this.advancedFilterForm.controls['vendorId'].setValue(0);
    } else {
      this.contChangeQuotationProcessIdZoom++;
    }
  }

  validateDisableDuplicate(quotation) {
    if (quotation.status == 1 || quotation.status == 5)
      return false;
    else
      return true;
  }

  duplicateQuotation(quotation) {   

    let indexQuotation = this.quotations.findIndex(q => 
      q.purchaseRequisition == quotation.purchaseRequisition &&
      q.vendor == quotation.vendor &&
      q.item == quotation.item &&
      q.seqQuotation == quotation.seqQuotation
    );

    let quotationDuplicate = { ...quotation};

    quotationDuplicate.seqQuotation = quotation.seqQuotation + 1;
    quotationDuplicate.isDuplicate = true;

    this.quotations.splice(indexQuotation + 1, 0, quotationDuplicate);
  }

  validateDisableDelete(quotation) {

    if (!quotation.approvedQuot)
      return false;
    else
      return true;

  }

  removeQuotation(quotation) {

    this.poDialog.confirm({
			title: this.literals['exclusion'],
			message: `${this.literals['exclusionQuotationMessage']}`,
			confirm: () => {

        let indexQuotation = this.quotations.findIndex(q => 
          q.purchaseRequisition == quotation.purchaseRequisition &&
          q.vendor == quotation.vendor &&
          q.item == quotation.item &&
          q.seqQuotation == quotation.seqQuotation
        );

				if (quotation.isDuplicate) {          

          this.quotations.splice(indexQuotation, 1);

        } else {

          this.quotationsIsLoading = true;

          const id = `${quotation.purchaseRequisition}||${quotation.vendor}||${quotation.item}||${quotation.seqQuotation}`
          
          this.subscription$.push(
            this.quotationService.delete(id)
              .subscribe({
                next: () => {
                  this.poNotification.success(this.literals['exclusionQuotationMessageSuccess']);
                  this.quotations.splice(indexQuotation, 1);
                  this.quotationsIsLoading = false;
                },
                error: (error) => {
                  this.quotationsIsLoading = false;
                  throw new Error(error);
                }
              })
          );
        }
			},
		});
  }
}
