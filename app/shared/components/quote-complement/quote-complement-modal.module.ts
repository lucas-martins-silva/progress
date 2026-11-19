import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { QuoteComplementModalComponent } from './quote-complement-modal.component';
import { PoModule } from '@po-ui/ng-components';
import { GenericsZoomService } from 'src/app/shared/services/generics-zoom.service';
import { CurrencyZoomService } from 'src/app/shared/services/currency.service';

@NgModule({
  declarations: [QuoteComplementModalComponent],
  imports: [CommonModule, PoModule, ReactiveFormsModule, FormsModule],
  exports: [QuoteComplementModalComponent],
  providers: [GenericsZoomService, CurrencyZoomService]
})
export class QuoteComplementModalModule { }
