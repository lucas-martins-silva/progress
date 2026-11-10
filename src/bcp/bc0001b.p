/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0001B 2.00.00.011} /*** "010011" 09/10/2025 11:26:27 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0001B MBC}
&ENDIF


/*******************************************************************************
**
**   Programa..: bc0001a.p
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Programa de Inicializaá∆o do COLETA DE DADOS Magnus I.00
**
*********************************************************************************/

{include/i-lgcode.i}
{cdp/cdcfgint.i}

def var cd-trans as char format "x(8)" extent 13
init ["Contagem",
      "Etiq-Avu",
      "Etiq-Rec",
      "Etiq-Fat",
      "Rep-Item",
      "Reporte ",
      "Req-MCP ",
      "Transf  ",
      "Embarque",
      "Etq-PrdL",
      "Etq-PrdS",
      "Codigo2D",
      "Req-OM"].

/***************
init ["MGContag",   /* Contagem Ciclica             */
      "MGEt-Avu",   /* Etiqueta Avulsa              */
      "MGEt-Rec",   /* Etiqueta Recebimento         */
      "MGEt-Fat",   /* Etiqueta Faturamento         */
      "MGRepRep",   /* Reporte Repetitivo           */
      "MGReport",   /* Reporte por Ordem            */
      "MGReqMcp",   /* Requisiá∆o de Materiais      */
      "MGTransf",   /* Transferencia                */
      "MGEmbarq",   /* Aviso de Embarque            */
      "MGEt-PrL",   /* Etiqueta Ordem Produá∆o Listagem    */
      "MGEt-PrS"].  /* Etiqueta Ordem Produá∆o Sumarizaá∆o */
***************/

&IF "{&language-code}" = "POR" &THEN
   def var descricao as char format "x(30)" extent 13
   init ["Contagem Ciclica              ",
         "Etiqueta Avulsa               ",
         "Etiqueta Recebimento          ",
         "Etiqueta Faturamento          ",
         "Reporte Repetitivo            ",
         "Reporte Produá∆o              ",
         "Requisiá∆o de Materiais       ",
         "Transferencia                 ",
         "Aviso de Embarque             ",
         "Etiquetas Ordem Prod.Listagem ",
         "Etiquetas Ordem Prod.Sumarizad",
         "C¢digo 2D                     ",
         "Requisiá∆o Ordem de Manutená∆o"].
&ENDIF

&IF "{&language-code}" = "ING" &THEN
   def var descricao as char format "x(30)" extent 13
   init ["Cycle Counting                ",
         "Detached Label                ",
         "Receiving Label               ",
         "Invoicing Label               ",
         "Repetitive Report             ",
         "Production Report             ",
         "Material Requirement          ",
         "Transference                  ",
         "Embark Advise                 ",
         "Report Production Order Label ",
         "Summary Production Order Label",
         "Code 2D                       ",
         "Maintenance Order Requisition"].
&ENDIF

&IF "{&language-code}" = "ESP" &THEN
   def var descricao as char format "x(30)" extent 13
   init ["Conteo Ciclico                ",
         "Etiqueta Avulsa               ",
         "Etiqueta Recepci¢n            ",
         "Etiqueta Facturaci¢n          ",
         "Reporte Repetitivo            ",
         "Reporte de Producci¢n         ",
         "Requisici¢n de Materiales     ",
         "Transferencia                 ",
         "Sapiente de Embarcarse        ",
         "Etiqueta Ordem Prod.Listagem  ",
         "Etiq Ordem Prod. Sintetizaci¢n",
         "C¢digo 2D                     ",
         "Solicit. Ordem Mantenimiento  "].
&ENDIF

def var api-atualizacao as char format "x(256)" extent 13
init["bcp/bc9002c.p",
     "             ",
     "             ",
     "             ",
     "bcp/bc9006c.p",
     "bcp/bc9003c.p",
     "bcp/bc9004c.p",
     "bcp/bc9001c.p",
     "bcp/bc9008c.p",
     "             ",
     "             ",
     "bcp/bc0110c.p",
     "bcp/bc9011c.p"].

def var prog-altera as char format "x(256)" extent 13
init["bcp/bc9002a.p",
     "bcp/bc0803.w ",
     "bcp/bc0803.w ",
     "bcp/bc0803.w ",
     "bcp/bc9006a.p",
     "bcp/bc9003a.p",
     "bcp/bc9004a.p",
     "bcp/bc9001a.p",
     "bcp/bc9008a.p",
     "bcp/bc0803.w ",
     "bcp/bc0803.w ",
     "bcp/bc0110a.p",
     "bcp/bc9011a.p"].

def var prog-etiq as char format "x(256)" extent 13
init["              ",
     "bcp/bcapi002.p",
     "bcp/bcapi002.p",
     "bcp/bcapi002.p",
     "bcp/bcapi002.p",
     "bcp/bcapi002.p",
     "              ",
     "bcp/bcapi002.p",
     "              ",
     "bcp/bcapi002.p",
     "bcp/bcapi002.p",
     "bcp/bcapi018.p",
     "              "].

def var prog-import as char format "x(256)" extent 13
init["bcp/bc9002b.p",
     "             ",
     "             ",
     "             ",
     "bcp/bc9006b.p",
     "bcp/bc9003b.p",
     "bcp/bc9004b.p",
     "bcp/bc9001b.p",
     "bcp/bc9008b.p",
     "             ",
     "             ",
     "             ",
     "             "].

def var prog-criacao as char format "x(256)" extent 13
init["              ",
     "bcp/bc0801.w  ",
     "rep/re0304cl.p",
     "ftp/ft0513cl.p",
     "cpp/cp0311cl.p",
     "cpp/cp0311cl.p",
     "              ",
     "cep/ce0206cl.p",
     "              ", 
     "bcp/bc0305cp.p",
     "bcp/bc0305cp.p",
     "ftp/ft0513bd.p",
     "              "].

def var prog-leitura as char format "x(256)" extent 14
init["bcp/bc9002.p",
     "bcp/bc0801.w",
     "            ",
     "            ",
     "bcp/bc9006.p",
     "bcp/bc9003.p",
     "bcp/bc9004.p",
     "bcp/bc9001.p",
     "bcp/bc9008.p",
     "            ",
     "            ",
     "bcp/bc0110.p",
     "bcp/bc9011.p"].

def var p-criacao as char format "x(256)" extent 13
init["      ",
     "bc0801",
     "re0304",
     "ft0513",
     "cp0324",
     "cp0311",
     "      ",
     "ce0206",
     "      ",
     "cp0305",
     "cp0304",
     "ft0513",
     "      "].
     
def var p-prog-char as char format "x(256)" extent 13
init["bc9002",
     "      ",
     "      ",
     "      ",
     "bc9006",
     "bc9003",
     "bc9004",
     "bc9001",
     "bc9008",
     "      ",
     "      ",
     "bc0110",
     "bc9011"].

def var p-leitura as char format "x(256)" extent 13
init["bc9002",
     "      ",
     "      ",
     "      ",
     "bc9006",
     "bc9003",
     "bc9004",
     "bc9001",
     "bc9008",
     "      ",
     "      ",
     "bc0110",
     "bc9011"].

def var i-cont as integer.

/* Inicializaá∆o da Tabela param-bc */

find  first param-bc EXCLUSIVE-LOCK NO-ERROR .
    if  not avail param-bc then
        create  param-bc.
    assign  param-bc.tp-etiq-padrao             = 99
            param-bc.tipo-etiq-total            = 99
            param-bc.pto-decimal                = yes
            param-bc.int-1                      = 3
            param-bc.char-1                     = "|"   /* Delimitador de campos na importaá∆o  */
            param-bc.nome-dir-etiq              = "c:/spool"
            param-bc.cod_servid_exec_import     = ""
            param-bc.cod_servid_exec_atualiz    = ""
            &if '{&mgcld_version}' <= '2.04' &then
                param-bc.int-2 = 2.  /* Define qual produto esta sendo utilizado 1-EMS, 2-Magnus I.00 */
            &else
                param-bc.ind-sistema = 2.
            &endif.
    
/* Inicializaá∆o da Tabela bc-param-mat */

find first bc-param-mat EXCLUSIVE-LOCK NO-ERROR .
    if  not avail bc-param-mat then
        create  bc-param-mat.
    assign  bc-param-mat.nr-contagem    = 1.


/*Luciano-02/07/2002*/    
do  i-cont = 1 to 13:
    find first bc-tipo-trans 
         where bc-tipo-trans.cd-trans = cd-trans[i-cont] 
         EXCLUSIVE-LOCK NO-ERROR.
    if  not avail bc-tipo-trans then
        create bc-tipo-trans.
    assign  bc-tipo-trans.cd-trans          = trim(cd-trans[i-cont])
            bc-tipo-trans.descricao         = trim(descricao[i-cont])
            bc-tipo-trans.prog-altera       = trim(prog-altera[i-cont])
            bc-tipo-trans.prog-etiq         = trim(prog-etiq[i-cont])
            bc-tipo-trans.api-atualizacao   = trim(api-atualizacao[i-cont])
            bc-tipo-trans.prog-import       = trim(prog-import[i-cont])
            bc-tipo-trans.prog-criacao      = trim(prog-criacao[i-cont])
            bc-tipo-trans.prog-leitura      = trim(prog-leitura[i-cont])
            bc-tipo-trans.char-1            = trim(cd-trans[i-cont])
            bc-tipo-trans.tipo-etiq-total   = 00.

    /* criar bc-prog-trans do programa de Criacao de Transaáao */

    do on error undo, next:
        find first bc-prog-trans
             where bc-prog-trans.cd-trans       = trim(cd-trans[i-cont])
               and bc-prog-trans.cod_prog_dtsul = trim(p-criacao[i-cont])
             EXCLUSIVE-LOCK NO-ERROR.
        if  not avail bc-prog-trans then
            if  trim(p-criacao[i-cont]) <> "" then
                create bc-prog-trans.
            else
                undo, next.
        assign  bc-prog-trans.cd-trans        = trim(cd-trans[i-cont])
                bc-prog-trans.cod_prog_dtsul  = trim(p-criacao[i-cont])
                bc-prog-trans.situacao-trans  = yes.
    end.

    /* criar bc-prog-trans do programa de Criacao de Transaáao na vers∆o caracter */
    
    do on error undo, next:
        find first bc-prog-trans
             where bc-prog-trans.cd-trans       = trim(cd-trans[i-cont])
               and bc-prog-trans.cod_prog_dtsul = trim(p-prog-char[i-cont])
             EXCLUSIVE-LOCK NO-ERROR.
        if  not avail bc-prog-trans then
            if  trim(p-prog-char[i-cont]) <> "" then
                create bc-prog-trans.
            else
                undo, next.
        assign  bc-prog-trans.cd-trans        = trim(cd-trans[i-cont])
                bc-prog-trans.cod_prog_dtsul  = trim(p-prog-char[i-cont])
                bc-prog-trans.situacao-trans  = yes.
    end.


   /* criar bc-prog-trans do programa de Leitura de Transaáao */

    do on error undo, next:
        find first bc-prog-trans
             where bc-prog-trans.cd-trans       = trim(cd-trans[i-cont])
               and bc-prog-trans.cod_prog_dtsul = trim(p-leitura[i-cont])
             EXCLUSIVE-LOCK NO-ERROR.
        if  not avail bc-prog-trans then
            if  trim(p-leitura[i-cont]) <> "" then
                create bc-prog-trans.
            else
                undo, next.
        assign  bc-prog-trans.cd-trans        = trim(cd-trans[i-cont])
                bc-prog-trans.cod_prog_dtsul  = trim(p-leitura[i-cont])
                bc-prog-trans.situacao-trans  = yes.
    end.

   /* Inicializaá∆o da Tabela bc-tipo-backflush */

    find first bc-tipo-backflush 
         where bc-tipo-backflush.cd-trans = trim(cd-trans[i-cont]) 
         EXCLUSIVE-LOCK NO-ERROR.
    if  not avail bc-tipo-backflush then
        create  bc-tipo-backflush.
    assign  bc-tipo-backflush.cd-trans          = trim(cd-trans[i-cont])
            bc-tipo-backflush.motivo-backflush  = 1
            bc-tipo-backflush.baixa-reserva     = 1
            bc-tipo-backflush.muda-status       = no
            bc-tipo-backflush.codigo-rejei      = 0
            bc-tipo-backflush.cod-cta-ctbl-aplic-unif   = ""
            bc-tipo-backflush.cod-ccusto-aplic-unif     = ""
            bc-tipo-backflush.cod-cta-ctbl-refugo-unif  = ""
            bc-tipo-backflush.cod-ccusto-refugo-unif    = "".

end.

/* Inicializaá∆o da Tabela tipo-etiqueta */

find first tipo-etiqueta
     where tipo-etiqueta.tipo-etiq = 99 EXCLUSIVE-LOCK NO-ERROR.
if  not avail tipo-etiqueta then
    create tipo-etiqueta.

{utp/ut-liter.i "Etiqueta Padr∆o Datasul" * L}
assign  tipo-etiqueta.tipo-etiq = 99
        tipo-etiqueta.titulo    = trim(return-value).

/* Inicializaá∆o da Tabela seq-tipo-etiqueta */

{bcp/bc0001.i1} /* Uni∆o das Inclides i01cl016.i, i02cl016.i, i03cl016.i    */
assign  i-cont  = 0.

for  each seq-tipo-etiqueta 
    where seq-tipo-etiqueta.tipo-etiq = 99 EXCLUSIVE-LOCK:
    delete seq-tipo-etiqueta.
end.

do i-cont = 1 to num-entries(c-lista):
    find first seq-tipo-etiqueta
         where seq-tipo-etiqueta.tipo-etiq = 99 
           and seq-tipo-etiqueta.sequencia = i-cont
         NO-LOCK NO-ERROR.
    if  not avail seq-tipo-etiqueta then do:
        create seq-tipo-etiqueta.
        assign  seq-tipo-etiqueta.tipo-etiq = 99
                seq-tipo-etiqueta.sequencia = i-cont
                seq-tipo-etiqueta.cod-campo = i-cont * 1000 + i-cont
                seq-tipo-etiqueta.char-1    = substring(entry(i-cont,c-lista),33,21)
                seq-tipo-etiqueta.int-1     = 
                                   (if  substring(seq-tipo-etiqueta.char-1,1,2) = "X("
                                        then 1
                                    else
                                        if  substring(seq-tipo-etiqueta.char-1,1,2) = ">>" 
                                            then 2
                                        else 0).
    end.
end.

&if '{&mgcld_version}' >= '2.02' &then
    run bcp/bc0001c.p. 
&else    
    for each bc-tipo-trans
        WHERE bc-tipo-trans.cd-trans = "Codigo2D" EXCLUSIVE-LOCK:
        delete bc-tipo-trans.
    end.

    for each bc-tipo-backflush
        WHERE bc-tipo-backflush.cd-trans = "Codigo2D" EXCLUSIVE-LOCK:
        delete bc-tipo-backflush.
    end.
    for each bc-prog-trans
        WHERE bc-prog-trans.cd-trans = "Codigo2D" EXCLUSIVE-LOCK:
        delete bc-prog-trans.
    end.
        
&endif

