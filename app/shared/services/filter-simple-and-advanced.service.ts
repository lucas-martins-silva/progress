import { Injectable } from '@angular/core';

@Injectable()
export class FilterSimpleAndAdvancedService {
	constructor() { }

	// campo = valor*
	simpleFilter(property: string, value: string): string {
		return `${property}=${value}*`;
	}

	// campo = valor
	equals(property: string, value: string): string {
		return `${property}=${value}`;
	}	

	// campo >= valor
	greaterThanOrEqual(property: string, value: string): string {
		return `${property} GE '${value}'`;
	}

	// campo <= valor
	lessThanOrEqual(property: string, value: string): string {
		return `${property} LE '${value}'`;
	}

	// campo >= valor AND campo <= valor
	greaterThanOrEqualAndLessThanOrEqual(property: string, startValue: string, endValue: string): string {
		let url;

		url = this.greaterThanOrEqual(property, startValue);
		url += ' AND ';
		url += this.lessThanOrEqual(property, endValue);

		return url;
	}

	clauseOrList(property: string, value: any) {
		let url = '(';

		for (let i = 0; i < value.length; i++ ) {
			url += `${property} EQ '${value[i]}'`;

			if (i < (value.length - 1)) {
				url += ' OR ';
			}
		}

		return url + ')';
	}
}
