/********************************************************************************************
**   Include...: bc9003.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Set/2000 - Luciano Leonhardt                                **
**                                                                                         **
**   Objetivo..: Armazenar os dados para transacao de Reporte por Ordem                    **
**                                                    Reporte por Operaá∆o                 **
**                                                    Reporte por Ponto de Controle        **
**                                                                                         **
********************************************************************************************/

Define {1} Temp-Table tt-reporte-ordem-bc NO-UNDO
    Field tipo                      As Integer      Format '>9'         Initial 1       Label 'Tipo Reporte'
    Field nr-reporte                As Integer      Format '>>9'                        Label 'Nr.Reporte'
    Field nr-ord-produ              As Integer      Format '>>>,>>>,>>9'                Label 'Nr.Ord.Produá∆o'
    Field data                      As Date         Format '99/99/9999'                 Label 'Data Fabricaá∆o'
    Field qt-reporte                As Decimal      Format '>>>>>>9.9999':U Decimals 4  Label 'Qtd.Reportada'
    Field qt-refugo                 As Decimal      Format '>>>>>>9.9999':U Decimals 4  Label 'Qtd.Refugada'
    Field qt-apr-cond               As Decimal      Format '>>>>>>9.9999':U Decimals 4  Label 'Qtd.Apr.Cond'
    Field it-codigo                 As Character    Format 'x(16)'                      Label 'Item'
    Field un                        As Character    Format 'x(03)'                      Label 'Un'
    Field nro-docto                 As Character    Format 'x(16)'                      Label 'Nr.Docto'
    Field serie-docto               As Character    Format 'x(05)'                      Label 'Serie'
    Field cod-depos                 As Character    Format 'x(03)'                      Label 'Depos.Aca'
    Field cod-localiz               As Character    Format 'x(20)'                      Label 'Local.Aca'
    Field dep-refugo                As Character    Format 'x(03)'                      Label 'Depos.Ref'
    Field loc-refugo                As Character    Format 'x(10)'                      Label 'Local.Ref'
    Field lote-serie                As Character    Format 'x(40)'                      Label 'Lote/Serie'
    Field cod-refer                 As Character    Format 'x(8)'                       Label 'Referencia'
    Field dt-vali-lote              As Date         Format '99/99/9999'                 Label 'Dt.Val.Lote'
    /*Inicio Alteraá‰es projeto - 107*/
    field cod-cta-codigo            as character    format 'x(20)'                      label 'Conta'
    field cod-ccusto-codigo         as character    format 'x(20)'                      label 'Centro de Custo'
    field cod-cta-refugo            as character    format 'x(20)'                      label 'Conta Refugo'
    field cod-ccusto-refugo         as character    format 'x(20)'                      label 'Centro de Custo Refugo'
    field cod-cta-aplic             as character    format 'x(20)'                      label 'Conta Aplicacao'
    field cod-ccusto-aplic          as character    format 'x(20)'                      label 'Centro de Custo Aplicacao'
    /*Fim alteraá‰es projeto - 107*/
    Field cod-depos-sai             As Character    Format 'x(03)'                      Label 'Depos.Sai'
    Field cod-local-sai             As Character    Format 'x(20)'                      Label 'Local.Sai'
    Field op-codigo                 As Integer      Format '>>9'                        Label 'Operaá∆o'
    Field cod-roteiro               As Character    Format 'x(08)'                      Label 'Roteiro'
    Field it-oper                   As Character    Format 'x(16)'                      Label 'Item Operaá∆o'
    Field pto-controle              As Integer      Format '>>9'                        Label 'Pto.Contr'
    Field sequencia                 As Integer      Format '>>9'                        Label 'Seq.Imp'
    Field baixa-reservas            As Integer      Format '>>9'        Initial 1       Label 'Baixa Reservas'
    Field time-out                  As Integer      Format '>>9'        Initial 30      Label 'Time-Out'
    Field tentativas                As Integer      Format '>>9'        Initial 10      Label 'Tentativas'
    Field procura-saldos            As Logical      Format 'Sim/N∆o'    Initial yes     Label 'Procura Saldos'
    Field carrega-reservas          As Logical      Format 'Sim/N∆o'    Initial yes     Label 'Carrega Reservas'
    Field requis-automatica         As Logical      Format 'Sim/N∆o'                    Label 'Req.Automatica'
    Field prog-seg                  As Character    Format 'x(12)'                      Label 'Prog.Chamador'
    Field finaliza-ordem            As Logical      Format 'Sim/N∆o'    Initial no      Label 'Finaliza Ordem'
    Field finaliza-oper             As Logical      Format 'Sim/N∆o'    Initial no      Label 'Finaliza Operaá∆o'
    Field reserva                   As Logical      Format 'Sim/N∆o'    Initial yes     Label 'Reservas'
    Field nro-ord-seq               As Integer      Format '>>9'                        Label 'Seq.Ordem'
    Field linha                     As Integer      Format '>>9'                        Label 'Linha'
    Field cod-versao-integracao     As Integer      Format '>>9'                        Label 'Vers∆o Integraá∆o'
    Field ct-refugo                 As Integer      Format '>>>>>>>9'                   Label 'Conta Refugo'
    Field sc-refugo                 As Integer      Format '>>>>9'                      Label 'SubConta Refugo'
    Field ct-codigo                 As Integer      Format '>>>>>>>9'                   Label 'Conta '
    Field sc-codigo                 As Integer      Format '>>>>9'                      Label 'SubConta'
    Field estado                    As Character    Format 'x(02)'                      Label 'Estado Ordem'
    Field data-transacao            As Date         Format '99/99/9999':U               Label 'Data Trans'
    Field cod-unico                 As Character    Format 'x(16)':U                    Label 'Codig Unico'
    Field cod-usuario               As Character    Format 'x(12)':U                    Label 'Usuario'
    Field tipo-movto                As Integer      Format '>9'                         Label 'TpMov'
    Field cd-mob-dir                As Character    Format 'x(05)':U                    Label 'CdMODir'
    Field gm-codigo                 As Character    Format 'x(09)':U                    Label 'Grupo M†quina'
    Field tipo-relogio              As Integer      Format '>9'                         Label 'TpRelog'
    Field hora-ini                  As Integer      Format '>>>9'                       Label 'Hr. Ini'
    Field min-ini                   As Integer      Format '>9'                         Label 'Min.Ini'
    Field hora-fim                  As Integer      Format '>>>9'                       Label 'Hr. Fim'
    Field min-fim                   As Integer      Format '>9'                         Label 'Min.Fim'
    Field Tempo-ini                 As Decimal      Format '>>>>>>>9.9999':U Decimals 4 Label 'Tempo Ini'
    Field Tempo-Fim                 As Decimal      Format '>>>>>>>9.9999':U Decimals 4 Label 'Tempo Fim'
    Field Centesimal-ini            As Decimal      Format '>>>>>>>9.9999':U Decimals 4 Label 'Centesimal Ini'
    Field Centesimal-Fim            As Decimal      Format '>>>>>>>9.9999':U Decimals 4 Label 'Centesimal Fim'
    Field tempo                     As Decimal      Format '>>>>>9.9999':U   Decimals 4 Label 'Tempo'
    Field minutos-report            As Integer      Format '>9'                         Label 'Min.Reporte'
    Field referencia                AS Character    Format 'x(10)':U                    Label 'Referencia'
    Field matr-func                 As Integer      Format '>>>>9'                      Label 'Matr.Func'
    Field op-final                  As Logical      Format 'Sim/N∆o'                    Label 'OpFinal'
    Field cod-livre-1               As Character    Format 'x(40)':U                    Label 'Cod Livre 1'
    Field cod-livre-2               As Character    Format 'x(40)':U                    Label 'Cod Livre 2'
    Field cod-livre-3               As Character    Format 'x(40)':U                    Label 'Cod Livre 3'
    Field num-livre-1               As Integer      Format '>>>>>>>9':U                 Label 'Num Livre 1'     
    Field num-livre-2               As Integer      Format '>>>>>>>9':U                 Label 'Num Livre 2'     
    Field num-livre-3               As Integer      Format '>>>>>>>9':U                 Label 'Num Livre 3'
    Field dec-livre-1               As Decimal      Format '>>>>>>9.9999':U Decimals 4  Label 'Dec Livre 1'
    Field dec-livre-2               As Decimal      Format '>>>>>>9.9999':U Decimals 4  Label 'Dec Livre 2'
    Field dec-livre-3               As Decimal      Format '>>>>>>9.9999':U Decimals 4  Label 'Dec Livre 3'
    Field log-livre-1               As Logical      Format 'Sim/N∆o'   Initial no       Label 'Log Livre 1'
    Field log-livre-2               As Logical      Format 'Sim/N∆o'   Initial no       Label 'Log Livre 2'
    Field log-livre-3               As Logical      Format 'Sim/N∆o'   Initial no       Label 'Log Livre 3'
    Field dat-livre-1               As Date         Format '99/99/9999'                 Label 'DataLivre 1'
    Field dat-livre-2               As Date         Format '99/99/9999'                 Label 'DataLivre 2'
    Field dat-livre-3               As Date         Format '99/99/9999'                 Label 'DataLivre 3'
    index codigo  is primary unique nr-ord-produ nro-ord-seq
    index reserva reserva.

/*****[ Documentaá∆o dos Campos ]**********************************************
/*************[ INICIO Campos Utilizados no Ems e no Magnus I00 ]*************/
Campos:
    1.) tipo..................: Tipo de Reporte (1-Por Ordem, 2-Por Operaá∆o, 3-Ponto de Controle)
    2.) nr-ord-produ..........: Numero Ordem Produá∆o
    3.) data..................: Data de Fabricaá∆o do Produto Acabado
    4.) qt-reporte............: Quantidade Reportada
    5.) qt-refugo.............: Quantidade Refugada
    6.) qt-apr-cond...........: Quantidade Aprovada Condicional
    7.) it-codigo.............: Item da Ordem de Produá∆o
    8.) un....................: Unidade de Medida do Item
    9.) nro-docto.............: Numero do Documento
   10.) serie-docto...........: Serie do Documento
   11.) cod-depos.............: Deposito Entrada Produto Acabado
   12.) cod-localiz...........: Localizaá∆o Entrada Produto Acabado
   13.) lote-serie............: Lote/Serie Produto Acabado
   14.) cod-refer.............: Referància Produto Acabado
   15.) dt-vali-lote..........: Data Validade Lote/Serie
   16.) cod-depos-sai.........: Deposito Saida Produto Acabado
   17.) cod-local-sai.........: Localizaá∆o Saida Produto Acabado
   18.) reserva...............: Monta Reservas (Utilizado somente processo Batch)
   19.) nro-ord-seq...........: Numero de Reportes
   20.) linha.................: Linha Produá∆o (Utilizado somente processo de Importaá∆o)
   21.) data-transacao........: Data da geraá∆o da Transaá∆o
   22.) cod-unico.............: C¢digo Unico gerado no Data Collection
   23.) cod-usuario...........: Usu†rio que esta gerando a transaá∆o
   24.) tipo-relogio..........: Tipo Rel¢gio
   25.) hora-ini..............: Hora Inicial
   26.) min-ini...............: Minuto Inicial
   27.) hora-fim..............: Hora Final
   28.) min-fim...............: Minuto Final
   29.) tempo.................: Tempo
   30.) referencia............: Referencia
   31.) matr-func.............: Matricula Funcionario

/*************[ FINAL  Campos Utilizados no Ems e no Magnus I00 ]*************/

/*****************[ INICIO Campos Utilizados somente no Ems ]****************/
/****************************************************************************/
Campos:
    1.) dep-refugo............: Deposito Refugo
    2.) loc-refugo............: Localizaá∆o Refugo
    3.) cod-cta-ctbl-unif.....: Conta
    4.) cod-ccusto-unif.......: Centro de Custo contabil
    5.) cod-cta-ctbl-refugo...: Conta Refugo
    6.) cod-ccusto-refugo.....: Centro de Custo Refugo
    7.) cod-cta-ctbl-aplic....: Conta Aplicaá∆o (Utilizada Somente quando o item for Debido Direto, Consignado,Controle Fisico)
    8.) cod-ccusto-aplic......: Centro de Custo Aplicacao (Utilizada Somente quando o item for Debido Direto, Consignado,Controle Fisico)   
    9.) op-codigo.............: Codigo da Operaá∆o
   10.) cod-roteiro...........: C¢digo do Roteiro
   11.) it-oper...............: Item da Operaá∆o
   12.) pto-controle..........: Codigo do Ponto de Controle
   13.) baixa-reservas........: Baixa Reservas
   14.) requis-automatica.....: Indica de faz a requisiá∆o ap¢s a operaá∆o ser completada
   15.) finaliza-ordem........: Indica se encerra a ordem
   16.) finaliza-oper.........: Indica se encerra a operaá∆o
   17.) tipo-movto............: Tipo Movimento
   18.) cd-mob-dir............: Codigo M∆o de Obra Direta
   19.) gm-codigo.............: C¢digo Grupo de M†quina
   20.) minutos-report........: Minutos Reportes

/*****************[ FINAL  Campos Utilizados somente no Ems ]****************/

/*************[ INICIO Campos Utilizados somente no Magnus I00 ]*************/
Campos:
    1.) ct-refugo.............: Conta Refugo
    2.) sc-refugo.............: SubConta Refugo
    3.) ct-codigo.............: Conta
    4.) sc-codigo.............: SubConta
    5.) op-final..............: Indica o Estado da Operaá∆o (Sim=Liberada, N∆o=Nao Iniciada)
    6.) Tempo-ini.............: Tempo Inicial
    7.) Tempo-Fim.............: Tempo Final
    8.) estado................: Estado da Ordem (   N=Nao Iniciada,
                                                    L=Liberada,
                                                    A=Alocaá∆o,
                                                    E=Emitida,
                                                    S=Separada,
                                                    R=Requisitada,
                                                    I=Iniciada,
                                                    F=Finalizada)
/*************[ FINAL  Campos Utilizados somente no Magnus I00 ]*************/

/*******************[ INICIO Campos de Uso Interno Datasul ]*****************/
/*******************[      N∆o Devem Ser Alimentados       ]*****************/ 
/****************************************************************************/
Campos:
    1.) nr-reporte............: Sequencia de Reportes
    2.) sequencia.............: Sequencia Importaá∆o
    3.) time-out..............: Campos Utilizado somente quando processo for via RPC
    4.) tentativas............: Campos Utilizado somente quando processo for via RPC
    5.) procura-saldos........: Indica se Procura Saldos (Utilizado somente se for para atualizar as reservas)
    6.) carrega-reservas......: Indica se o sub-programas utiliza Reservas Envias (Modo Persistente)
    7.) prog-seg..............: Nome do programa chamador
    8.) cod-versao-integracao.: C¢digo vers∆o de integraá∆o
    9.) Centesimal-ini........: Tempo Inicial
   10.) Centesimal-Fim........: Tempo Final
/*****************[ FINAL  Campos Utilizados somente no Ems ]****************/

*******************************************************************************/
