import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/api_provider.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../recetas/recetas_providers.dart';
import 'pedidos_providers.dart';
import '../../theme/kitchy_colors.dart';
import '../../theme/kitchy_typography.dart';
import '../../theme/kitchy_spacing.dart';
import '../../theme/kitchy_shadows.dart';

class LineaFormData {
  String nombre;
  String? recetaId;
  int cantidad;
  String precio;
  double precioUnitario;

  LineaFormData({
    this.nombre = '',
    this.recetaId,
    this.cantidad = 1,
    this.precio = '',
    this.precioUnitario = 0.0,
  });
}

class NuevoPedidoScreen extends ConsumerStatefulWidget {
  const NuevoPedidoScreen({super.key});

  @override
  ConsumerState<NuevoPedidoScreen> createState() => _NuevoPedidoScreenState();
}

class _NuevoPedidoScreenState extends ConsumerState<NuevoPedidoScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores de texto para campos principales
  final _nombreController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _puntoEntregaController = TextEditingController();
  final _notasController = TextEditingController();

  DateTime _fechaSeleccionada = DateTime.now();
  TimeOfDay? _horaSeleccionada;
  bool _isLoading = false;
  
  // Lista dinámica de líneas
  List<LineaFormData> _lineas = [LineaFormData()];

  @override
  void dispose() {
    _nombreController.dispose();
    _whatsappController.dispose();
    _puntoEntregaController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Widget _timeChip(TimeOfDay time) {
    final isActive = _horaSeleccionada?.hour == time.hour && _horaSeleccionada?.minute == time.minute;
    final timeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    
    return InkWell(
      onTap: () {
        setState(() {
          _horaSeleccionada = time;
        });
      },
      borderRadius: BorderRadius.circular(KitchyRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? KitchyColors.primary : KitchyColors.chipUnselected,
          borderRadius: BorderRadius.circular(KitchyRadius.pill),
        ),
        child: Text(
          timeString,
          style: isActive ? KitchyTypography.chipActive : KitchyTypography.chipInactive,
        ),
      ),
    );
  }

  void _guardarPedido() async {
    if (!_formKey.currentState!.validate()) return;

    if (_horaSeleccionada == null) {
      _mostrarError('Por favor, selecciona una hora de entrega.');
      return;
    }

    final fechaEntregaFinal = DateTime(
      _fechaSeleccionada.year,
      _fechaSeleccionada.month,
      _fechaSeleccionada.day,
      _horaSeleccionada!.hour,
      _horaSeleccionada!.minute,
    );

    if (fechaEntregaFinal.isBefore(DateTime.now())) {
      _mostrarError('La fecha de entrega debe ser en el futuro.');
      return;
    }

    // Validar líneas
    for (var linea in _lineas) {
      if (linea.nombre.trim().isEmpty) {
        _mostrarError('Todos los productos deben tener un nombre.');
        return;
      }
      if (linea.precio.trim().isEmpty || double.tryParse(linea.precio) == null) {
        _mostrarError('Por favor, ingresa un precio válido para todos los productos.');
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final lineasPost = _lineas.map((l) => LineaPedidoCreate(
        nombreProducto: l.nombre.trim(),
        recetaId: l.recetaId,
        cantidadPorciones: l.cantidad,
        precioAcordadoMxn: double.tryParse(l.precio.trim()) ?? 0.0,
      )).toList();

      final body = PedidoCreate(
        clienteNombre: _nombreController.text.trim(),
        clienteWhatsapp: _whatsappController.text.trim().isEmpty ? null : _whatsappController.text.trim(),
        fechaEntrega: fechaEntregaFinal.toUtc(), // Asegurar UTC o formato correcto
        puntoEntrega: _puntoEntregaController.text.trim().isEmpty ? null : _puntoEntregaController.text.trim(),
        notas: _notasController.text.trim().isEmpty ? null : _notasController.text.trim(),
        lineas: lineasPost,
      );

      final api = ref.read(apiProvider);
      final response = await api.apiV1PedidosPost(body: body);

      if (response.isSuccessful) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Pedido registrado!'),
            backgroundColor: Color(0xFF16A34A),
          ),
        );
        ref.invalidate(pedidosProvider); // Refrescar la lista principal
        context.pop();
      } else {
        _mostrarError('Error del servidor: ${response.error}');
      }
    } catch (e) {
      _mostrarError('Ocurrió un error inesperado.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: const Color(0xFFBA1A1A), // Error color
      ),
    );
  }

  Widget _sectionLabel(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        number.isEmpty ? text : '$number. $text',
        style: KitchyTypography.sectionLabel,
      ),
    );
  }

  InputDecoration _kitchyInputDecoration({
    required String hintText,
    Widget? suffixIcon,
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: KitchyTypography.body.copyWith(color: KitchyColors.textDisabled),
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: KitchyColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KitchyRadius.medium),
        borderSide: const BorderSide(color: KitchyColors.border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KitchyRadius.medium),
        borderSide: const BorderSide(color: KitchyColors.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KitchyRadius.medium),
        borderSide: const BorderSide(color: KitchyColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _stepperButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: KitchyColors.border, width: 1.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: KitchyColors.textPrimary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KitchyColors.background,
      appBar: AppBar(
        backgroundColor: KitchyColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: KitchyColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: Text('KITCHY', style: KitchyTypography.logo),
        centerTitle: true,
        actions: const [
          CircleAvatar(
            radius: 18,
            backgroundColor: KitchyColors.border,
            child: Icon(Icons.person, color: KitchyColors.textSecondary, size: 18),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFC69E57)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nuevo Pedido', style: KitchyTypography.heading1),
                    const SizedBox(height: 8),
                    Text(
                      'Completa los detalles para agendar la entrega.',
                      style: KitchyTypography.body.copyWith(color: KitchyColors.textSecondary),
                    ),
                    const SizedBox(height: KitchySpacing.sectionGap),

                    // --- FECHA Y HORA ---
                    _sectionLabel('1', 'FECHA Y HORA DE ENTREGA'),
                    // Calendario Inline
                    Container(
                      decoration: BoxDecoration(
                        color: KitchyColors.surface,
                        borderRadius: BorderRadius.circular(KitchyRadius.large),
                        boxShadow: KitchyShadows.card,
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: KitchyColors.primary,
                            onPrimary: Colors.white,
                            onSurface: KitchyColors.textPrimary,
                          ),
                          textTheme: TextTheme(
                            bodyMedium: KitchyTypography.bodyBold,
                          ),
                        ),
                        child: CalendarDatePicker(
                          initialDate: _fechaSeleccionada,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          onDateChanged: (date) {
                            setState(() {
                              _fechaSeleccionada = date;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Chips de Hora
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _timeChip(const TimeOfDay(hour: 9, minute: 0)),
                          const SizedBox(width: 8),
                          _timeChip(const TimeOfDay(hour: 11, minute: 30)),
                          const SizedBox(width: 8),
                          _timeChip(const TimeOfDay(hour: 14, minute: 0)),
                          const SizedBox(width: 8),
                          _timeChip(const TimeOfDay(hour: 17, minute: 30)),
                          const SizedBox(width: 8),
                          // "Otra..."
                          InkWell(
                            onTap: () async {
                              final hora = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: KitchyColors.primary,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (hora != null) {
                                setState(() {
                                  _horaSeleccionada = hora;
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(KitchyRadius.pill),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: KitchyColors.chipUnselected,
                                borderRadius: BorderRadius.circular(KitchyRadius.pill),
                              ),
                              child: Text(
                                _horaSeleccionada != null && ![_horaSeleccionada?.hour == 9 && _horaSeleccionada?.minute == 0, _horaSeleccionada?.hour == 11 && _horaSeleccionada?.minute == 30, _horaSeleccionada?.hour == 14 && _horaSeleccionada?.minute == 0, _horaSeleccionada?.hour == 17 && _horaSeleccionada?.minute == 30].contains(true) 
                                  ? _horaSeleccionada!.format(context) 
                                  : 'Otra...',
                                style: KitchyTypography.chipInactive.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: KitchySpacing.sectionGap),

                    // --- CLIENTE ---
                    _sectionLabel('2', 'CLIENTE'),
                    TextFormField(
                      controller: _nombreController,
                      style: KitchyTypography.bodyBold,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      decoration: _kitchyInputDecoration(hintText: 'Ej. Elena Rodríguez'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'El nombre es requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _whatsappController,
                      style: KitchyTypography.bodyBold,
                      keyboardType: TextInputType.phone,
                      decoration: _kitchyInputDecoration(
                        hintText: 'WhatsApp (Opcional)',
                        prefixText: '+52 ',
                      ),
                    ),

                    const SizedBox(height: KitchySpacing.sectionGap),

                    // --- PRODUCTOS ---
                    _sectionLabel('3', 'PRODUCTOS'),
                    
                    // Lista Dinámica de Productos
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _lineas.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _buildLineaProducto(index);
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Botón Añadir Producto
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _lineas.add(LineaFormData());
                        });
                      },
                      icon: const Icon(Icons.add_circle_outline, color: KitchyColors.textSecondary, size: 18),
                      label: Text('Añadir Producto', style: KitchyTypography.buttonSecondary),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: KitchyColors.border, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(KitchyRadius.medium),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),

                    const SizedBox(height: KitchySpacing.sectionGap),

                    // --- DETALLES OPCIONALES ---
                    Text('Detalles Opcionales', style: KitchyTypography.heading1.copyWith(fontSize: 18)),
                    const SizedBox(height: 16),
                    _sectionLabel('', 'PUNTO DE ENTREGA'),
                    TextFormField(
                      controller: _puntoEntregaController,
                      style: KitchyTypography.bodyBold,
                      decoration: _kitchyInputDecoration(
                        hintText: 'Calle, número, departamento...',
                        suffixIcon: const Icon(Icons.location_on_outlined, color: KitchyColors.iconMuted),
                      ),
                    ),
                    const SizedBox(height: KitchySpacing.itemGap),
                    _sectionLabel('', 'NOTAS DEL PEDIDO'),
                    TextFormField(
                      controller: _notasController,
                      style: KitchyTypography.body,
                      maxLines: 3,
                      decoration: _kitchyInputDecoration(
                        hintText: 'Ej: Dejar en recepción, sin gluten...',
                      ),
                    ),

                    const SizedBox(height: 32),

                    // --- BOTÓN GUARDAR ---
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _guardarPedido,
                        icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                        label: Text('Guardar Pedido', style: KitchyTypography.button),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: KitchyColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(KitchyRadius.button),
                          ),
                          shadowColor: const Color(0x33C49A3C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLineaProducto(int index) {
    final recetasAsync = ref.watch(recetasProvider);
    
    return Container(
      padding: const EdgeInsets.all(KitchySpacing.cardPadding),
      decoration: BoxDecoration(
        color: KitchyColors.surface,
        borderRadius: BorderRadius.circular(KitchyRadius.medium),
        border: Border.all(color: KitchyColors.border, width: 1),
        boxShadow: KitchyShadows.card,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen placeholder
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: KitchyColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(KitchyRadius.small),
                  border: Border.all(color: KitchyColors.border),
                ),
                child: const Icon(Icons.fastfood_outlined, color: KitchyColors.iconMuted),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    recetasAsync.when(
                      data: (recetas) {
                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: _kitchyInputDecoration(hintText: 'Selecciona un producto').copyWith(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          style: KitchyTypography.bodyBold,
                          value: _lineas[index].recetaId,
                          items: recetas.map((r) {
                            return DropdownMenuItem<String>(
                              value: r.id,
                              child: Text(r.nombre, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _lineas[index].recetaId = val;
                              if (val != null) {
                                final r = recetas.firstWhere((element) => element.id == val);
                                _lineas[index].nombre = r.nombre;
                                
                                double costoInsumos = 0;
                                for (var ing in r.ingredientes) {
                                  final pCompra = double.tryParse(ing.insumo.precioCompra.toString()) ?? 0.0;
                                  final cComprada = double.tryParse(ing.insumo.cantidadComprada.toString()) ?? 1.0;
                                  final cUsada = double.tryParse(ing.cantidadUsada.toString()) ?? 0.0;
                                  if (cComprada > 0) {
                                    costoInsumos += (pCompra / cComprada) * cUsada;
                                  }
                                }
                                
                                double costoGastos = 0;
                                for (var gasto in r.gastosOcultos) {
                                  if (gasto.activo == true) {
                                    final valor = double.tryParse(gasto.valor.toString()) ?? 0.0;
                                    if (gasto.esPorcentaje == true) {
                                      costoGastos += costoInsumos * (valor / 100);
                                    } else {
                                      costoGastos += valor;
                                    }
                                  }
                                }
                                
                                final costoTotal = costoInsumos + costoGastos;
                                final porciones = r.porciones > 0 ? r.porciones : 1;
                                final costoPorPorcion = costoTotal / porciones;
                                final margen = double.tryParse(r.margenPct.toString()) ?? 0.0;
                                final precioSugerido = costoPorPorcion * (1 + (margen / 100));
                                
                                _lineas[index].precioUnitario = precioSugerido;
                                _lineas[index].precio = (precioSugerido * _lineas[index].cantidad).toStringAsFixed(2);
                              }
                            });
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => TextFormField(
                        initialValue: _lineas[index].nombre,
                        onChanged: (val) => _lineas[index].nombre = val,
                        decoration: _kitchyInputDecoration(hintText: 'Producto'),
                        style: KitchyTypography.bodyBold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_lineas[index].precio}',
                      style: KitchyTypography.priceTotal,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Controles de cantidad
              Row(
                children: [
                  _stepperButton(Icons.remove, () {
                    if (_lineas[index].cantidad > 1) {
                      setState(() {
                        _lineas[index].cantidad--;
                        if (_lineas[index].precioUnitario > 0) {
                          _lineas[index].precio = (_lineas[index].precioUnitario * _lineas[index].cantidad).toStringAsFixed(2);
                        }
                      });
                    }
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('${_lineas[index].cantidad}', style: KitchyTypography.quantity),
                  ),
                  _stepperButton(Icons.add, () {
                    setState(() {
                      _lineas[index].cantidad++;
                      if (_lineas[index].precioUnitario > 0) {
                        _lineas[index].precio = (_lineas[index].precioUnitario * _lineas[index].cantidad).toStringAsFixed(2);
                      }
                    });
                  }),
                ],
              ),
              // Botón eliminar línea (si hay más de 1)
              if (_lineas.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Color(0xFFBA1A1A)),
                  onPressed: () {
                    setState(() {
                      _lineas.removeAt(index);
                    });
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
