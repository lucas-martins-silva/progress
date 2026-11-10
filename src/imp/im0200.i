/*******************************************************************************
**
**   IM0200.I - Emiss∆o de Declaraá‰es e Comunicaá‰es. 
**   pi-imprime-embarque
**
*******************************************************************************/

/* Parametros ******************************************************************
{1} - historico-proc-imp/historico-embarque
{2} - nr-proc-imp/embarque
{3} - proc-imp/embarq-imp
*******************************************************************************/                       
    &IF DEFINED(bf-mat-comex) &THEN
        {cdp/cd2507.i {1} {3}}  /* Verifica se a declaracao vai ser impressa */       
    &else
        If can-find(FIRST funcao where funcao.cd-funcao = "spp-caraiba-fo897776" and funcao.ativo = yes)  THEN DO:
           {imp/im0200.i9 {1} {3}}  /* Verifica se a declaracao vai ser impressa, ser† executada somente quando estiver funá∆o cadastrada */   
        END.
        ELSE DO:
            IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-imp-dt-prev" AND funcao.ativo) THEN DO:
                {imp/im0200.i13 {1} {3}}  /* Verifica se a declaracao vai ser impressa */      
            END.
            ELSE DO:
                {cdp/cd2507.i {1} {3}}  /* Verifica se a declaracao vai ser impressa */   
            END.
        END.
    &ENDIF
    
    if  tt-param.l-traduz then do:
        find emitente-cex where
             emitente-cex.cod-emitente = emitente.cod-emitente
             no-lock no-error.
        if avail emitente-cex then do:       
            {imp/im9999.i1 "Emitente" "emitente.cod-emitente" "emitente-cex" "f-declaracao"}            
            {imp/im9999.i1 "Endereáo" "emitente.endereco" "emitente-cex" "f-declaracao"}            
            {imp/im9999.i1 "Bairro" "emitente.bairro" "emitente-cex" "f-declaracao"}
            {imp/im9999.i1 "CEP" "emitente.cep" "emitente-cex" "f-declaracao"}            
            {imp/im9999.i1 "Estado" "emitente.estado" "emitente-cex" "f-declaracao"}            
            {imp/im9999.i  "Processo Imp" "c-processo" "emitente-cex"}            
            {imp/im9999.i  "Pto Embarque" "c-embarq" "emitente-cex"}            
            {imp/im9999.i  "Pto Nacionalizaá∆o" "c-desemb" "emitente-cex"}
            {imp/im9999.i  "Seleá∆o" "c-lb-tit-sel" "emitente-cex"}            
            {imp/im9999.i  "Impress∆o" "c-lb-tit-imp" "emitente-cex"}            
            {imp/im9999.i  "Seleá∆o" "c-lb-tit-sel" "emitente-cex"}            
            {imp/im9999.i  "Destino" "c-lb-destino" "emitente-cex"}           
            {imp/im9999.i  "Usu†rio" "c-lb-usuario" "emitente-cex"}
        end.     
    end. 
    
    {imp/im9999.i2 "c-processo" "18"} /*Preenchimento dos espaáos por pontinho*/
    {imp/im9999.i2 "c-embarq" "18"}
    {imp/im9999.i2 "c-desemb" "18"}
    {imp/im9999.i2 "c-lb-destino" "10"}
    {imp/im9999.i2 "c-lb-usuario" "10"}

    if l-imprime then do: 
       
       if avail tt-processo-imp then do:
         if processo-imp.nr-proc-imp < tt-processo-imp.c-nr-proc-imp then
            find tt-processo-imp where
                 tt-processo-imp.c-nr-proc-imp = processo-imp.nr-proc-imp no-error.
       end.

       FIND FIRST tt-processo-imp NO-LOCK NO-ERROR.
       IF AVAIL tt-processo-imp THEN
           assign c-nr-proc-imp-aux = tt-processo-imp.c-nr-proc-imp.

       IF c-nr-proc-imp-aux = "" THEN
          LEAVE.

       disp emitente.cod-emitente
            emitente.nome-emit
            emitente.endereco
            emitente.bairro
            emitente.cidade
            emitente.cep  
            emitente.estado
            emitente.pais
            with frame f-declaracao.

       disp c-processo
            c-nr-proc-imp-aux
            with frame f-lbl-processo.
       down with frame f-lbl-processo.

       for each tt-processo-imp:
           if tt-processo-imp.c-nr-proc-imp = c-nr-proc-imp-aux THEN DO:
              ASSIGN c-nr-proc-imp-aux = "".
              next.
           END.                         

           disp codepage-convert(tt-processo-imp.c-nr-proc-imp, "iso8859-1", "ibm850") @ tt-processo-imp.c-nr-proc-imp
                with frame f-nr-processo.
           down with frame f-nr-processo.
       end.

       disp 
           c-embarq
           itinerario.pto-embarque
           c-desc-embarq
           c-desemb
           itinerario.pto-desembarque
           c-desc-desemb
           with frame f-processo2.

       for each tt-editor:
           delete tt-editor.
       end.

       /* c-verifica-modulo Ç carregada com o m¢dulo que est† utilizando a include de convers∆o
          das vari†veis */

       assign c-verifica-modulo = "IMP".
       assign i-pos-f = 0.
       assign c-linha-desc = decl-hist-{3}.texto
              i-pos-fim = r-index(c-linha-desc,"&")
              l-carrega-desc = yes.

       {cdp/cd2550.i1} /* Substitui as vari†veis cadastradas no texto da Declaraá∆o/Comunicaá∆o pelo
                          seu respectivo valor na base */

       if c-nro-invoice[1] <> "" then do:
          run pi-print-editor (c-inicio, 73).
          find first tt-editor no-error.
          disp tt-editor.conteudo when avail tt-editor
               with frame f-decl-texto.
          for each tt-editor where
                   tt-editor.linha >= 1:
              disp tt-editor.conteudo when avail tt-editor
                   with frame f-decl-texto.
              down with frame f-decl-texto.
          end.
          put skip(1).
          disp c-nro-invoice-label 
               c-parcela-label
               c-dt-vencim-label
               c-vl-invoice-label with frame f-fatura-label.
          down with frame f-fatura-label.

          do  i-conta = 1 to i-num - 1:
              assign c-nro-invoice-aux = trim(c-nro-invoice[i-conta])
                     c-parcela-aux     = trim(c-parcela[i-conta])
                     c-dt-vencim-aux   = trim(c-dt-vencim[i-conta])
                     de-vl-invoice-aux  = de-vl-invoice[i-conta].

              disp c-nro-invoice-aux
                   c-parcela-aux
                   c-dt-vencim-aux
                   de-vl-invoice-aux with frame f-fatura.
              down with frame f-fatura.
          end.
          put skip(1). 

          run pi-print-editor (c-linha-desc, 73).
          for each tt-editor where
                   tt-editor.linha > 1:
              disp tt-editor.conteudo when avail tt-editor
                   with frame f-decl-texto-aux.
              down with frame f-decl-texto-aux.
          end.
          ASSIGN c-var = ""
                 c-nro-invoice[1] = "".
       end.
       else do: 
            run pi-print-editor (c-linha-desc, 73).
            find first tt-editor no-error.
            disp tt-editor.conteudo when avail tt-editor
                 with frame f-decl-texto.
            down with frame f-decl-texto.
            for each tt-editor where
                     tt-editor.linha > 1:
                disp tt-editor.conteudo when avail tt-editor
                     with frame f-decl-texto.
                down with frame f-decl-texto.         
                if line-counter >= 60 then do:
                   put skip.
                   page.
                end.
            end.            
       end.

       page.
        
       assign decl-hist-{3}.decl-emitida = yes.

       FOR EACH tt-processo-imp:
           DELETE tt-processo-imp.
       END.
    end.
    
    down with frame f-declaracao.
    
                             
/* IM0200.I */
