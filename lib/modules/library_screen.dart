import 'package:flutter/material.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/utils/vdict_service.dart';
import 'package:nodyslexia/utils/db_service.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<_TuDienTabState> _dictKey = GlobalKey<_TuDienTabState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildPlaceholderSection(String title, String message, IconData icon) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 80,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 16.0),
              child: Text('Thư viện', style: textTheme.displayLarge),
            ),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Văn bản'),
                Tab(text: 'Từ nổi bật'),
                Tab(text: 'Từ điển'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _buildPlaceholderSection(
                    'Lịch sử Văn bản',
                    'Các văn bản được chuyển đổi từ file sẽ được lưu tại đây.',
                    Icons.history_edu_outlined,
                  ),
                  TuNoiBatTab(
                    onWordTap: (word) {
                      _tabController.animateTo(2);
                      Future.delayed(const Duration(milliseconds: 200), () {
                        _dictKey.currentState?.searchFromOutside(word);
                      });
                    },
                  ),
                  TuDienTab(key: _dictKey),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 24.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[ReturnButton(), SettingButton()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TuNoiBatTab extends StatefulWidget {
  final Function(String) onWordTap;

  const TuNoiBatTab({super.key, required this.onWordTap});

  @override
  State<TuNoiBatTab> createState() => _TuNoiBatTabState();
}

class _TuNoiBatTabState extends State<TuNoiBatTab> {
  List<String> _words = [];

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final data = await DBService.getWords();
    setState(() => _words = data);
  }

  Future<void> _deleteWord(String word) async {
    await DBService.deleteWord(word);
    _loadWords();
  }

  @override
  Widget build(BuildContext context) {
    if (_words.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.bookmark_border_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              "Từ Đã Đánh Dấu",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Danh sách các từ bạn đã đánh dấu sẽ xuất hiện ở đây.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _words.length,
      itemBuilder: (context, index) {
        final word = _words[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(
              word,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onTap: () => widget.onWordTap(word),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteWord(word),
            ),
          ),
        );
      },
    );
  }
}

class TuDienTab extends StatefulWidget {
  const TuDienTab({super.key});

  @override
  State<TuDienTab> createState() => _TuDienTabState();
}

class _TuDienTabState extends State<TuDienTab>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  String? _result;
  bool _isLoading = false;

  @override
  bool get wantKeepAlive => true; // Giữ trạng thái tab

  Future<void> _search() async {
    final tu = _controller.text.trim();
    if (tu.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    final nghia = await VDictService.traTuVietViet(tu);

    setState(() {
      _isLoading = false;
      _result = nghia;
    });
  }

  void searchFromOutside(String word) {
    _controller.text = word;
    _search();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // bắt buộc khi dùng keepAlive
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: "Nhập từ cần tra",
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _search(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _search, child: const Text("Tìm")),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _result == null
                    ? const Center(child: Text("Nhập từ để tra cứu"))
                    : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              _result!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await DBService.addWord(_controller.text.trim());
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Đã thêm vào Từ nổi bật"),
                              ),
                            );
                          },
                          icon: const Icon(Icons.bookmark),
                          label: const Text("Lưu vào Từ nổi bật"),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}
