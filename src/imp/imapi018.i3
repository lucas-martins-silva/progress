/* Subseá∆o Respons†vel pelo Transporte (TRA) */

/* Tipo */
CREATE ttFormatLine.
ASSIGN ttFormatLine.cInfo   = c-tipo-tra
       ttFormatLine.iIniPos = 1
       ttFormatLine.iLength = 3.

/* CPF/CNPJ Transportadora */
CREATE ttFormatLine.
ASSIGN ttFormatLine.cInfo   = c-cpf-cnpf-transp
       ttFormatLine.iIniPos = 4
       ttFormatLine.iLength = 14.

/* Raz∆o Social Transportadora */
CREATE ttFormatLine.
ASSIGN ttFormatLine.cInfo   = c-razao-socal-transp
       ttFormatLine.iIniPos = 18
       ttFormatLine.iLength = 70.
