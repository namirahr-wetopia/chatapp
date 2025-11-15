import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PoliciesPage extends StatelessWidget {
  final Map<String, String> policies;

  const PoliciesPage({super.key, required this.policies});

  Future<void> _launchURL(String urlString) async {
    try {
      final uri = Uri.parse(urlString);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        final canLaunch = await canLaunchUrl(uri);
        if (!canLaunch) {
          Get.snackbar(
            'Cannot Open Link',
            'No app found to open this URL',
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open link: ${e.toString()}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final policyKeys = policies.keys.toList();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Policies',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: policies.length,
        separatorBuilder: (_, __) => const Divider(
          color: Colors.grey,
          thickness: 0.8,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final title = policyKeys[index];
          final url = policies[title]!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              onPressed: () => _launchURL(url),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  const Icon(
                    Icons.chevron_right_sharp,
                    color: Colors.grey,
                    size: 30,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
