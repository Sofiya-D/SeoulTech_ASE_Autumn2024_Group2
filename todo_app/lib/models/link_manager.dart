// link_manager.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkManager extends StatefulWidget {
  final List<String> links;
  final Function(List<String>) onLinksUpdated;

  const LinkManager({
    super.key,
    required this.links,
    required this.onLinksUpdated,
  });

  @override
  _LinkManagerState createState() => _LinkManagerState();
}

class _LinkManagerState extends State<LinkManager> {
  final TextEditingController _linkController = TextEditingController();

  String _extractDomain(String url) {
    Uri? uri = Uri.tryParse(url);
    if (uri?.host == null) return url;
    return uri!.host;
  }

  void _addLink() {
    if (_linkController.text.isNotEmpty) {
      String url = _linkController.text;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }
      
      List<String> updatedLinks = List.from(widget.links)..add(url);
      widget.onLinksUpdated(updatedLinks);
      _linkController.clear();
    }
  }

  void _removeLink(int index) {
    List<String> updatedLinks = List.from(widget.links)..removeAt(index);
    widget.onLinksUpdated(updatedLinks);
  }

  Future<void> _launchURL(String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible d\'ouvrir le lien')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _linkController,
                  decoration: InputDecoration(
                    labelText: 'Ajouter un lien',
                    hintText: 'https://example.com',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _addLink(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _addLink,
              ),
            ],
          ),
        ),
        if (widget.links.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(widget.links.length, (index) {
                final url = widget.links[index];
                return Card(
                  child: InkWell(
                    onTap: () => _launchURL(url),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.link, size: 16),
                          SizedBox(width: 8),
                          Text(
                            _extractDomain(url),
                            style: TextStyle(fontSize: 14),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, size: 16),
                            onPressed: () => _removeLink(index),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
