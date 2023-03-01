**free
//==============================================================================
//@name.....: CATP001
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Mantenimiento de Tabla Categorías de Productos - CATEGORIA
//==============================================================================

//******************************************
// ESPECIFICACIONES DE ENCABEZADO
//******************************************
ctl-opt datfmt(*ISO);
ctl-opt debug(*YES);
ctl-opt bnddir('VENTAS');

// Etiquetas para mensajes y teclas de función de la pantalla
/include LIBDGR/QSRCTXT,VTSX001
// Lógica de acceso a datos de Categorías y Bitácora de Categorías
/include LIBDGR/QSRCTXT,CATP00201X

//******************************************
// DECLARACIÓN DE ARCHIVOS
//******************************************
dcl-f CATP001FM workstn sfile(PANTSF:gpReg) indds(IndicadoresPantalla_DS);

//******************************************
// DECLARACIÓN DE PROCEDIMIENTOS EXTERNOS
//******************************************
dcl-pr CATP001_BuscarMensajes extpgm('VTSC001');
  pArchivoMensaje     char(10) const;
  pCodigoMensaje      char(7)  const;
  pDescripcionMensaje char(80);
end-pr;

//******************************************
// DECLARACIÓN DE ESTRUCTURAS DE DATOS
//******************************************
dcl-ds IndicadoresPantalla_DS;
  nAgregar                      ind pos(01);
  nSalir                        ind pos(03);
  nEliminar                     ind pos(04);
  nRefrescar                    ind pos(05);
  nIncluir                      ind pos(06);
  nBuscar                       ind pos(10);
  nCancelar                     ind pos(12);
  nAceptar                      ind pos(23);
  nBorrarRegistrosSubArchivo    ind pos(50);
  nVisualizarRegistroSubArchivo ind pos(51);
  nRegistroSiguiente            ind pos(52);
  NVisualizarControlSubArchivo  ind pos(53);
  nPosicionarCursor2            ind pos(73);
  nOverlayPantallas             ind pos(95);
end-ds;

dcl-ds programDs psds qualified;
  programName *proc;
end-ds;

dcl-ds dsCategoryInfo likeds(CATP00201_DScategoryDetail);
dcl-ds dsCategoryLogInfo likeds(CATP00201_DScategoryLogDetail);

//******************************************
// DECLARACIÓN DE VARIABLES GLOBALES
//******************************************
dcl-s User          char(18) inz(*user);
dcl-s gpReg         packed(4:0);
dcl-s Accion        char(1);
dcl-s inicio        ind inz(*on);
dcl-s evento        char(1) inz;
dcl-s gnValidar     ind;
dcl-s gnEntro       ind;

//******************************************
// DECLARACIÓN DE CONSTANTES
//******************************************
dcl-c AccionRegistro '1';
dcl-c OpcModificar   '2';
dcl-c OpcEliminar    '4';
dcl-c OpcConsultar   '5';
dcl-c INCLUIR        'I';
dcl-c ACTUALIZAR     'A';
dcl-c ELIMINAR       'E';

//------------------------------------------------------------------------------
//                                   PRINCIPAL
//------------------------------------------------------------------------------
//@paramin..: @i_parametroAccion -> Código de acción.
//@paramout.: N/A
//------------------------------------------------------------------------------
//@exception: VTS0002 -> Opción no es válida.
//------------------------------------------------------------------------------
dcl-pr CATP001;
  @i_parametroAccion char(1);
end-pr;
dcl-pi CATP001;
  @i_parametroAccion char(1);
end-pi;

  Accion = @i_parametroAccion;
  PGM = programDs.programName;
  FAMENSAJES = *blanks;

  dow (not nSalir); // Mientras no se presione F3, continuar
    FOPCION = *blanks;
    select;
      when (Accion = AccionRegistro);
        FATITULO = OPC1;
        FATECLAS = TEC1;
        CATP001_CargarDatosEnSubfile();
    endsl;

    if (gnEntro);
      FAMENSAJES = *blanks;
      exfmt PANTSFC; // Formato de registro: subfile control
    endif;

    select;
      when (nSalir); // Si presiona F3
        leave;
      when (nRefrescar); // Si presiona F5
        FATITULO = OPC1;
        CATP001_CargarDatosEnSubfile();
        iter;
      when ((nIncluir) and (Accion = AccionRegistro)); // Si presiona F6
        CATP001_Insertar();
        iter;
      other;
        if (gpReg > *zeros);
          readc PANTSF; // Leer la primer opción ingresada en el subfile
          dow (not %eof());
            select;
              when (FOPCION = OpcConsultar); // Si es opción 5=Consultar
                FOPCION = *blanks;
                CATP001_Consultar();
              when (FOPCION = OpcModificar and Accion = AccionRegistro); // Si es opción 2=Modif.
                FOPCION = *blanks;
                CATP001_Actualizar();
              when (FOPCION = OpcEliminar); // Si es opción 4=Eliminar
                FOPCION = *blanks;
                CATP001_Eliminar();
              other; // Opción no es válida
                FAMENSAJES = CATP001_BuscarMSJ('VENTASMSGF':'VTS0002');
            endsl;
            readc PANTSF; // Leer la siguiente opción ingresada en el subfile
          enddo;
          Accion = AccionRegistro;
        endif;
    endsl;
  enddo;

  *inlr = *on;

//------------------------------------------------------------------------------
//@name.....: CATP001_CargarDatosEnSubfile
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Cargar los datos de la tabla base al subfile (pantalla).
//------------------------------------------------------------------------------
//@paramin..: N/A
//@paramout.: N/A
//------------------------------------------------------------------------------
//@exception: N/A
//------------------------------------------------------------------------------
dcl-proc CATP001_CargarDatosEnSubfile;
  dcl-pi *n;
  end-pi;
  dcl-s  tmpCategoryDetail char(24) inz(*blanks);

  clear dsCategoryInfo;
  nBorrarRegistrosSubArchivo = *on;
  nVisualizarRegistroSubArchivo = *off;
  nVisualizarControlSubArchivo = *off;
  gpReg = *zeros;
  write PANTSFC; // Escribir subfile control
  FABUSQUEDA = %trim(FABUSQUEDA:'0');

  if (CATP00201_getAllCategories(FABUSQUEDA));
    dow (CATP00201_getNextCategory(dsCategoryInfo));
      gnEntro = *on;
      FCATIDCATE = dsCategoryInfo.categoryId;
      FCATDESCRI = dsCategoryInfo.categoryDescription;
      tmpCategoryDetail = %trim(dsCategoryInfo.categoryDetail);
      FCATDETALE = tmpCategoryDetail;
      gpReg = gpReg + 1;
      write PANTSF; // Escribir subfile
    enddo;
    if (gpReg <= *zeros);
      nBorrarRegistrosSubArchivo = *off;
      if (inicio);
        nVisualizarRegistroSubArchivo = *on;
      endif;
      gnEntro = *on;
    else;
      nBorrarRegistrosSubArchivo = *off;
      if (gpreg > 13);
        nRegistroSiguiente = *off;
      endif;
    endif;
  endif;
  CATP00201_closeAllCategoriesCursor();
  nOverlayPantallas = *on;
  write FUNCION; // Escribir pie del subfile
  inicio =*off;

end-proc;

//------------------------------------------------------------------------------
//@name.....: CATP001_Insertar
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Insertar el registro en la tabla base CATEGORIA y en la tabla
//            bitácora CATEGORIAB.
//------------------------------------------------------------------------------
//@paramin..: N/A
//@paramout.: N/A
//------------------------------------------------------------------------------
//@exception: VTS0003 -> Registro ingresado exitosamente.
//            VTS0006 -> Error al ingresar registro. Favor reintentar.
//------------------------------------------------------------------------------
dcl-proc CATP001_Insertar;
  dcl-pi *n;
  end-pi;

  evento = INCLUIR;
  TITULO = MSJ1;
  FATECLAS2 = TEC2;
  FAMENSAJE2 = *blanks;
  CATP001_InicializarCampos();

  dow (not nCancelar); // Mientras no se presione F12, continuar
    exfmt PANT03; // Formato de registro: agregar registro
    FAMENSAJE2 = *blanks;
    if (nCancelar); // Si presiona F12
      leave;
    else;
      gnValidar = CATP001_ValidarDatosPantalla(evento);
      if ((nAgregar) and (gnValidar)); // Si presiona F1 y datos ingresados en pantalla están OK
        monitor;
          dsCategoryInfo.categoryId = PCATIDCATE;
          dsCategoryInfo.categoryDescription = PCATDESCRI;
          dsCategoryInfo.categoryDetail = PCATDETALE;
          CATP001_AsignarValoresBitacora(evento);
          if (CATP00201_insertCategory(dsCategoryInfo));
            if (CATP00201_insertCategoryLog(dsCategoryLogInfo));
              exec sql commit;
              CATP001_InicializarCampos();
              nPosicionarCursor2 = *on;
              FAMENSAJE2 = CATP001_BuscarMSJ('VENTASMSGF':'VTS0003');
            else;
              exec sql rollback;
              FAMENSAJE2 = CATP001_BuscarMSJ('VENTASMSGF':'VTS0006');
            endif;
          else;
            exec sql rollback;
            FAMENSAJE2 = CATP001_BuscarMSJ('VENTASMSGF':'VTS0006');
          endif;
        on-error;
          exec sql rollback;
          FAMENSAJE2 = CATP001_BuscarMSJ('VENTASMSGF':'VTS0006');
        endmon;
      endif;
    endif;
  enddo;

  nCancelar = *off;

end-proc;

//------------------------------------------------------------------------------
//@name.....: CATP001_InicializarCampos
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Inicializa los campos de pantalla.
//            Inicializa los sub-campos de la DS.
//------------------------------------------------------------------------------
//@paramin..: N/A
//@paramout.: N/A
//------------------------------------------------------------------------------
//@exception: N/A
//------------------------------------------------------------------------------
dcl-proc CATP001_InicializarCampos;
  dcl-pi *n;
  end-pi;

  clear PCATIDCATE;
  clear PCATDESCRI;
  clear PCATDETALE;
  clear dsCategoryInfo;
  clear dsCategoryLogInfo;

end-proc;

//------------------------------------------------------------------------------
//@name.....: CATP001_ValidarDatosPantalla
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Validar la entrada de los campos de pantalla. Si hay algún error,
//            muestra un mensaje al usuario.
//------------------------------------------------------------------------------
//@paramin..: @i_evento -> Tipo de evento 'I'-Insertar, 'A'-Actualizar.
//@paramout.: ind -> Indicador 'true' si datos de pantalla están OK, sino 'false'.
//------------------------------------------------------------------------------
//@exception: VTS0009 -> Id de categoría en blanco.
//            VTS0010 -> Descripción de categoría en blanco.
//            VTS0011 -> Detalle de categoría en blanco.
//------------------------------------------------------------------------------
dcl-proc CATP001_ValidarDatosPantalla;
  dcl-pi *n ind;
    @i_evento char(1) const;
  end-pi;

  FAMENSAJE2 = *blanks;

  if (@i_evento = 'I');
    select;
      when (PCATIDCATE = *blanks);
        FAMENSAJE2 = CATP001_BuscarMSJ('VENTASMSGF':'VTS0009');
        return *off;
    endsl;
  endif;

  if ((@i_evento = 'I') or (@i_evento = 'A'));
    select;
      when (PCATDESCRI = *blanks);
        FAMENSAJE2 = CATP001_BuscarMSJ('VENTASMSGF':'VTS0010');
        return *off;
      when (PCATDETALE = *blanks);
        FAMENSAJE2 = CATP001_BuscarMSJ('VENTASMSGF':'VTS0011');
        return *off;
    endsl;
  endif;

  return *on;

end-proc;

//------------------------------------------------------------------------------
//@name.....: CATP001_AsignarValoresBitacora
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Asignar los valores de los campos de pantalla y demás, a los sub-
//            campos de la DS de la tabla bitácora.
//------------------------------------------------------------------------------
//@paramin..: @i_evento -> Tipo de evento 'I'-Insertar, 'A'-Actualizar, 'E'-Eliminar.
//@paramout.: N/A
//------------------------------------------------------------------------------
//@exception: N/A
//------------------------------------------------------------------------------
dcl-proc CATP001_AsignarValoresBitacora;
  dcl-pi *n;
    @i_evento char(1) const;
  end-pi;

  // Sub-campos de la DS de la tabla bitácora
  dsCategoryLogInfo.categoryId = PCATIDCATE;
  dsCategoryLogInfo.eventDate = %timestamp;
  dsCategoryLogInfo.categoryDescription = PCATDESCRI;
  dsCategoryLogInfo.categoryDetail = PCATDETALE;
  dsCategoryLogInfo.eventType = @i_evento;
  dsCategoryLogInfo.eventUser = User;

end-proc;

//------------------------------------------------------------------------------
//@name.....: CATP001_Consultar
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Consultar el registro seleccionado.
//------------------------------------------------------------------------------
//@paramin..: N/A
//@paramout.: N/A
//------------------------------------------------------------------------------
//@exception: N/A
//------------------------------------------------------------------------------
dcl-proc CATP001_Consultar;
  dcl-pi *n;
  end-pi;
  dcl-s tmpFCATIDCATE char(5) inz(*blanks);

  TITULO = MSJ2;
  FATECLAS2 = TEC3;
  FAMENSAJE2 = *blanks;
  tmpFCATIDCATE = FCATIDCATE;
  CATP001_InicializarCampos();

  if (CATP00201_getCategory(tmpFCATIDCATE:dsCategoryInfo));
    PCATIDCATE = dsCategoryInfo.categoryId;
    PCATDESCRI = dsCategoryInfo.categoryDescription;
    PCATDETALE = dsCategoryInfo.categoryDetail;
  endif;

  dow (not nCancelar); // Mientras no se presione F12, continuar
    exfmt PANT02; // Formato de registro: consultar registro
  enddo;
  nCancelar = *off;

end-proc;

//------------------------------------------------------------------------------
//@name.....: CATP001_Actualizar
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Actualizar el registro actual en la tabla base CATEGORIA e insertar
//            el registro anterior en la tabla bitácora CATEGORIAB.
//------------------------------------------------------------------------------
//@paramin..: N/A
//@paramout.: N/A
//------------------------------------------------------------------------------
//@exception: VTS0001 -> Error en ejecución de proceso.
//            VTS0004 -> Registro actualizado exitosamente.
//            VTS0007 -> Error al actualizar registro. Favor reintentar.
//            VTS0012 -> Error al actualizar. Descripción y detalle no se han
//                       modificado.
//------------------------------------------------------------------------------
dcl-proc CATP001_Actualizar;
  dcl-pi *n;
  end-pi;
  dcl-s modifActivada ind      inz(*off);
  dcl-s tmpFCATIDCATE char(5)  inz(*blanks);
  dcl-s tmpPCATDESCRI char(30) inz(*blanks);
  dcl-s tmpPCATDETALE char(50) inz(*blanks);

  monitor;
    evento = ACTUALIZAR;
    TITULO = MSJ3;
    FATECLAS2 = TEC4;
    FAMENSAJE2 = *blanks;
    tmpFCATIDCATE = FCATIDCATE;
    CATP001_InicializarCampos();

    if (CATP00201_getCategory(tmpFCATIDCATE:dsCategoryInfo));
      modifActivada = *on;

      PCATIDCATE = dsCategoryInfo.categoryId;
      PCATDESCRI = dsCategoryInfo.categoryDescription;
      PCATDETALE = dsCategoryInfo.categoryDetail;

      tmpPCATDESCRI = dsCategoryInfo.categoryDescription;
      tmpPCATDETALE = dsCategoryInfo.categoryDetail;

      CATP001_AsignarValoresBitacora(evento);
    endif;

    dow (not nCancelar); // Mientras no se presione F12, continuar
      exfmt PANT01; // Formato de registro: actualizar registro
      select;
        when (nCancelar); // Si presiona F12
          leave;
        when (nAgregar); // Si presiona F1
          if ((modifActivada = *on) and (CATP001_ValidarDatosPantalla(evento)));
            if ((PCATDESCRI <> tmpPCATDESCRI) or (PCATDETALE <> tmpPCATDETALE));
              // Setear nuevos valores para campos: descripción y detalle
              dsCategoryInfo.categoryDescription = PCATDESCRI;
              dsCategoryInfo.categoryDetail = PCATDETALE;
              if (CATP00201_updateCategory(dsCategoryInfo));
                if (CATP00201_insertCategoryLog(dsCategoryLogInfo));
                  exec sql commit;
                  FAMESSAGE = CATP001_BuscarMSJ('VENTASMSGF':'VTS0004');
                  exfmt MESSAGE; // Formato de registro: mensaje
                  leave;
                else;
                  exec sql rollback;
                  FAMENSAJE2 = CATP001_BuscarMSJ('VENTASMSGF':'VTS0007');
                endif;
              else;
                exec sql rollback;
                FAMENSAJE2 = CATP001_BuscarMSJ('VENTASMSGF':'VTS0007');
              endif;
            else;
              FAMENSAJE2 = CATP001_BuscarMSJ('VENTASMSGF':'VTS0012');
            endif;
          endif;
        other; // Si presiona Enter
          CATP001_ValidarDatosPantalla(evento);
      endsl;
    enddo;
    nCancelar = *off;

  on-error;
    FAMENSAJE2 = CATP001_BuscarMSJ('VENTASMSGF':'VTS0001');
    exfmt PANT01; // Formato de registro: actualizar registro
  endmon;

end-proc;

//------------------------------------------------------------------------------
//@name.....: CATP001_Eliminar
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Eliminar el registro actual en la tabla base CATEGORIA e insertar
//            dicho registro en la tabla bitácora CATEGORIAB.
//------------------------------------------------------------------------------
//@paramin..: N/A
//@paramout.: N/A
//------------------------------------------------------------------------------
//@exception: VTS0001 -> Error en ejecución de proceso.
//            VTS0005 -> Registro eliminado exitosamente.
//            VTS0008 -> Error al eliminar registro. Favor reintentar.
//------------------------------------------------------------------------------
dcl-proc CATP001_Eliminar;
  dcl-pi *n;
  end-pi;
  dcl-s tmpFCATIDCATE char(5) inz(*blanks);

  monitor;
    evento = ELIMINAR;
    TITULO = MSJ4;
    FATECLAS2 = TEC5;
    FAMENSAJE2 = *blanks;
    tmpFCATIDCATE = FCATIDCATE;
    CATP001_InicializarCampos();

    if (CATP00201_getCategory(tmpFCATIDCATE:dsCategoryInfo));
      PCATIDCATE = dsCategoryInfo.categoryId;
      PCATDESCRI = dsCategoryInfo.categoryDescription;
      PCATDETALE = dsCategoryInfo.categoryDetail;
      CATP001_AsignarValoresBitacora(evento);
    endif;

    dow (not nCancelar);
      exfmt PANT05; // Formato de registro: eliminar registro
      select;
        when (nCancelar); // Mientras no se presione F12, continuar
          leave;
        other;
          if (nAgregar); // Si presiona F1
            FAAVISO = MSJ5;
            exfmt PANT04; // Formato de registro: aviso
            select;
              when (nCancelar);
                leave;
              when (nAceptar);
                if (CATP00201_deleteCategory(dsCategoryInfo.categoryId));
                  if (CATP00201_insertCategoryLog(dsCategoryLogInfo));
                    exec sql commit;
                    FAMESSAGE = CATP001_BuscarMSJ('VENTASMSGF':'VTS0005');
                    exfmt MESSAGE; // Formato de registro: mensaje
                    leave;
                  else;
                    exec sql rollback;
                    FAMENSAJE2 = CATP001_BuscarMSJ('VENTASMSGF':'VTS0008');
                  endif;
                else;
                  exec sql rollback;
                  FAMENSAJE2 = CATP001_BuscarMSJ('VENTASMSGF':'VTS0008');
                endif;
            endsl;
          endif;
      endsl;
    enddo;
    nCancelar = *off;

  on-error;
    FAMENSAJE2 = CATP001_BuscarMSJ('VENTASMSGF':'VTS0001');
    exfmt PANT05; // Formato de registro: eliminar registro
  endmon;

end-proc;

//------------------------------------------------------------------------------
//@name.....: CATP001_BuscarMSJ
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Buscar la descripción del mensaje a partir del archivo de mensaje
//            y del código de mensaje recibidos, para mostrarla en pantalla.
//------------------------------------------------------------------------------
//@paramin..: @i_archivoMensaje     -> Archivo de mensaje.
//            @i_codigoMensaje      -> Código de mensaje.
//@paramout.: @o_descripcionMensaje -> Descripción de mensaje.
//------------------------------------------------------------------------------
//@exception: N/A
//------------------------------------------------------------------------------
dcl-proc CATP001_BuscarMSJ;
  dcl-pi *n char(80);
    @i_archivoMensaje char(10) const;
    @i_codigoMensaje  char(7)  const;
  end-pi;
  dcl-s @o_descripcionMensaje char(80);

  CATP001_BuscarMensajes(@i_archivoMensaje:@i_codigoMensaje:@o_descripcionMensaje);

  return @o_descripcionMensaje;

end-proc;
