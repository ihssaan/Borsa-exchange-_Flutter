import 'package:borsam/servis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model.dart';

class BorsaScreen extends StatefulWidget {
  @override
  _BorsaScreenState createState() => _BorsaScreenState();
}

class _BorsaScreenState extends State<BorsaScreen> {
  final BorsamService _service = BorsamService();
  Borsam? _borsamData;
  List<Result>? _filteredData;
  bool _isLoading = true;
  bool _isListView = false; // Liste görünümü mü, kart görünümü mü?

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final data = await _service.fetchBorsamData();
    setState(() {
      _borsamData = data;
      _filteredData = data?.result;
      _isLoading = false;
    });
  }

  void _filterData(String query) {
    setState(() {
      _filteredData = _borsamData?.result
              ?.where((item) =>
                  item.text!.toLowerCase().contains(query.toLowerCase()))
              .toList() ??
          [];
    });
  }

  void _toggleView() {
    setState(() {
      _isListView = !_isListView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.red],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Hisse Senetleri', style: TextStyle(color: Colors.white)),
            Row(
              children: [
                IconButton(
                  icon: Icon(_isListView ? Icons.grid_view : Icons.list,
                      color: Colors.white),
                  onPressed: _toggleView,
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Ara...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                    onChanged: _filterData,
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _filteredData == null || _filteredData!.isEmpty
              ? Center(child: Text('Veri alınamadı'))
              : _isListView
                  ? ListView.separated(
                      itemCount: _filteredData!.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey.shade400,
                        thickness: 0.8,
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        final result = _filteredData![index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(result.text ?? 'Bilinmeyen'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Son Fiyat: ${result.lastprice ?? 0}'),
                                Text('En Yüksek Fiyat: ${result.max ?? 0}'),
                                Text('En Düşük Fiyat: ${result.min ?? 0}'),
                              ],
                            ),
                            trailing: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: (result.rate ?? 0) >= 0
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${(result.rate ?? 0) > 0 ? "+" : ""}${result.rate ?? 0}%',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HisseDetayScreen(result: result),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          (_filteredData!.length + 1) ~/ 2,
                          (rowIndex) {
                            int startIndex = rowIndex * 2;
                            int endIndex = startIndex + 2;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                endIndex > _filteredData!.length
                                    ? _filteredData!.length - startIndex
                                    : 2,
                                (columnIndex) {
                                  int index = startIndex + columnIndex;
                                  if (index >= _filteredData!.length) {
                                    return SizedBox.shrink();
                                  }
                                  final result = _filteredData![index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HisseDetayScreen(
                                                    result: result),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: SizedBox(
                                          width: 150,
                                          height: 180, // Yükseklik artırıldı
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              result.iconUrl != null &&
                                                      result.iconUrl!.isNotEmpty
                                                  ? Image.network(
                                                      result.iconUrl!,
                                                      width: 50,
                                                      height: 50)
                                                  : SizedBox.shrink(),
                                              SizedBox(height: 4),
                                              Text(result.text ?? 'Bilinmeyen',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 4),
                                              Text(
                                                  'Son Fiyat: ${result.lastprice ?? 0}',
                                                  textAlign: TextAlign.center),
                                              SizedBox(height: 4),
                                              Text(
                                                  'En Yüksek Fiyat: ${result.max ?? 0}',
                                                  textAlign: TextAlign.center),
                                              SizedBox(height: 4),
                                              Text(
                                                  'En Yüksek Fiyat: ${result.min ?? 0}',
                                                  textAlign: TextAlign.center),
                                              SizedBox(height: 4),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4, horizontal: 8),
                                                decoration: BoxDecoration(
                                                  color: (result.rate ?? 0) >= 0
                                                      ? Colors.green
                                                      : Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '${(result.rate ?? 0) > 0 ? "+" : ""}${result.rate ?? 0}%',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
    );
  }
}

class HisseDetayScreen extends StatelessWidget {
  final Result result;

  HisseDetayScreen({required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(result.text ?? 'Hisse Detayı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kod: ${result.code ?? "Bilinmiyor"}',
                style: TextStyle(fontSize: 18)),
            Text('Son Fiyat: ${result.lastprice ?? 0}',
                style: TextStyle(fontSize: 18)),
            Row(
              children: [
                Text(
                  'Değişim Oranı: ',
                  style: TextStyle(fontSize: 18),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: (result.rate ?? 0) >= 0 ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${(result.rate ?? 0) > 0 ? "+" : ""}${result.rate ?? 0}%',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
