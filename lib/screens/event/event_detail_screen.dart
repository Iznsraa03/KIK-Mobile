import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kik_mobile/api/api_image_url.dart';
import 'package:kik_mobile/models/event.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // You could show a snackbar here to inform the user
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = ApiImageUrl.build(event.gambar);

    return Scaffold(
      floatingActionButton: event.linkPendaftaran.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _launchUrl(event.linkPendaftaran),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Daftar Sekarang'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280.0,
            pinned: true,
            stretch: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image,
                          size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.judul,
                      style: GoogleFonts.lato(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      context,
                      icon: Icons.calendar_today_outlined,
                      label: 'Tanggal & Waktu',
                      value: DateFormat('dd MMMM yyyy, HH:mm', 'id_ID')
                          .format(event.waktuPelaksanaan),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      icon: Icons.location_on_outlined,
                      label: 'Wilayah',
                      value: event.wilayah,
                    ),
                    const Divider(height: 40, thickness: 1),
                    Text(
                      'Deskripsi Event',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      event.deskripsi,
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.black87.withOpacity(0.7),
                          height: 1.5),
                    ),
                    if (event.media != null && event.media!.isNotEmpty)
                      _buildMediaGallery(context, event.media!),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaGallery(BuildContext context, List<String> media) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 40, thickness: 1),
        Text(
          'Galeri Media',
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: media.length,
            itemBuilder: (context, index) {
              final mediaUrl = ApiImageUrl.build(media[index]);
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    mediaUrl,
                    width: 180,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 180,
                        height: 120,
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.broken_image)),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context,
      {required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 22),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
