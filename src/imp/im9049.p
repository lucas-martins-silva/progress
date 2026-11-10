/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9049 2.00.00.007 } /*** "010007" 21/03/2025 09:24:36  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9049 MIM}
&ENDIF

{cdp/cdcfgmat.i}
{include/i-epc200.i im9049} /** Upc **/

    define input parameter pc-serie-docto          as character no-undo.
    define input parameter pc-nro-docto            as character no-undo.
    define input parameter pi-cod-emitente         as integer   no-undo.
    define input parameter pc-nat-operacao         as character no-undo.
    define input parameter pl-nf-simples-remes     as logical   no-undo.
    define input parameter pi-idi-nf-simples-remes as integer   no-undo.

    find docum-est
        where docum-est.serie-docto  = pc-serie-docto
        and   docum-est.nro-docto    = pc-nro-docto
        and   docum-est.cod-emitente = pi-cod-emitente
        and   docum-est.nat-operacao = pc-nat-operacao exclusive-lock no-error.
    if  avail docum-est then do:

        FOR FIRST embarque-imp FIELD(cod-transportador) NO-LOCK
             WHERE embarque-imp.embarque    = &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
                                                 docum-est.embarque
                                              &ELSE
                                                 substring(docum-est.char-1,1,20)
                                              &endif
               AND embarque-imp.cod-estabel = docum-est.cod-estabel: END.
        IF AVAIL embarque-imp THEN DO:
            FOR FIRST transporte NO-LOCK
                 WHERE transporte.cod-transp = embarque-imp.cod-transportador:
              &IF '{&bf_mat_versao_ems}' >= "2.062" &THEN
                 ASSIGN  docum-est.nome-transp     = transporte.nome-abrev.
              &else
                 ASSIGN OVERLAY(docum-est.char-2,102,12) = transporte.nome-abrev.  
              &ENDIF
            END.
        END. 

        if  pl-nf-simples-remes then do:  /** nf simples remessa **/ 
        
            if  pi-idi-nf-simples-remes = 1 then do: /** nf simples remessa mae **/   
                for each  item-doc-est
                    where item-doc-est.serie-docto  = docum-est.serie-docto
                    and   item-doc-est.nro-docto    = docum-est.nro-docto
                    and   item-doc-est.cod-emitente = docum-est.cod-emitente
                    and   item-doc-est.nat-operacao = docum-est.nat-operacao exclusive-lock:

                    find first ordem-compra 
                         where ordem-compra.numero-ordem = item-doc-est.numero-ordem no-lock no-error.
                    if  avail ordem-compra then do:
                        find first prazo-compra 
                             where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                               and prazo-compra.parcela      = item-doc-est.parcela exclusive-lock no-error.

                        IF TRIM(SUBSTRING(item-doc-est.char-2,940,1)) <> "S":U THEN DO:
                            if avail prazo-compra then
                                assign prazo-compra.dec-1 = 0
                                       item-doc-est.dec-1 = 0.
                        END.
                    end.
                    
                    IF TRIM(substring(item-doc-est.char-2,940,1)) <> "S":U THEN DO:
                        assign item-doc-est.encerra-pa   = no
                               &if '{&bf_mat_versao_ems}':U >= '2.06':U &then
                                   item-doc-est.num-ord-import  = item-doc-est.numero-ordem
                                   item-doc-est.num-parc-import = item-doc-est.parcela
                               &else
                                   overlay(item-doc-est.char-2, 145, 8) = trim(string(item-doc-est.numero-ordem))
                                   overlay(item-doc-est.char-2, 154, 5) = trim(string(item-doc-est.parcela))
                               &endif
                               item-doc-est.parcela      = 0
                               item-doc-est.numero-ordem = 0
                               item-doc-est.num-pedido   = 0
                               item-doc-est.narrativa    = "":U
                               item-doc-est.nr-ord-produ  = 0
                               item-doc-est.baixa-ce     = no
                               item-doc-est.item-pai     = "":U
                               item-doc-est.num-ord-inv  = 0.
                    END.
                end.
                &if '{&bf_mat_versao_ems}':U >= '2.06':U &then
                    assign docum-est.idi-nf-simples-remes = 1. 
                &else
                    assign overlay(docum-est.char-2,101,1) = "1":U. 
                &endif
            end.
            else do: /** nf simples remessa filha **/
                &if '{&bf_mat_versao_ems}':U >= '2.06':U &then
                    assign docum-est.idi-nf-simples-remes = 2. 
                &else
                    assign overlay(docum-est.char-2,101,1) = "2":U. 
                &endif
                
                /*******************  Chamada EPC Vicunha ********************/        

                for each tt-epc
                    where tt-epc.cod-event = "Apos-Gravar-NFilha-Docto":
                    delete tt-epc.
                end.

                create tt-epc.
                assign tt-epc.cod-event     = "Apos-Gravar-NFilha-Docto"
                       tt-epc.cod-parameter = "NFilha-Docto"
                       tt-epc.val-parameter = string(rowid(docum-est)).

                {include/i-epc201.i "Apos-Gravar-NFilha-Docto"}

            end.
        end.
    end.
    

   
        
