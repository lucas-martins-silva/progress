import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { QuotationPageComponent } from './quotation-page.component';


const routes: Routes = [
    {
        path: '',
        component: QuotationPageComponent
    },
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class QuotationPageRoutingModule { }

