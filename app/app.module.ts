import { LOCALE_ID, NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { PoModule, PoI18nConfig, PoI18nModule } from '@po-ui/ng-components';
import { HttpClientModule } from '@angular/common/http';
import { TranslateService } from 'dts-backoffice-util';
import { registerLocaleData } from '@angular/common';
import localePt from '@angular/common/locales/pt';
import { generalPt } from './shared/literals/i18n/general-pt';
import { generalEn } from './shared/literals/i18n/general-en';
import { generalEs } from './shared/literals/i18n/general-es';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MessageService } from '@totvs-frame-datasul/dts-fnd-utils';

registerLocaleData(localePt);
export const i18nConfig: PoI18nConfig = {
	default: {
		context: 'general',
		cache: true,
		language: localStorage.getItem('user.language') || navigator.language
	},
	contexts: {
		general: {
			'pt-BR': generalPt,
			'en-US': generalEn,
			'es': generalEs
		}
	}
};

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    PoModule,
    PoI18nModule.config(i18nConfig),
    HttpClientModule,
    BrowserAnimationsModule
  ],
  providers: [
    { provide: LOCALE_ID, useValue: TranslateService.getCurrentLanguage() },
    MessageService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
