import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:google_fonts/google_fonts.dart';
import 'category_menu.dart';

class CategoryButton extends StatefulWidget {
  final Function(String) onCategorySelected; // Callback untuk mengupdate kategori
  final bool isEditPage; // Flag untuk halaman edit

  const CategoryButton({
    super.key,
    required this.onCategorySelected,
    this.isEditPage = false, // Default false
  });

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  String selectedCategory = 'kategori'; // Kategori default

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    widget.onCategorySelected(category); // Panggil callback untuk mengupdate kategori
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPopover(
        context: context,
        bodyBuilder: (context) => CategoryMenu(
          onCategorySelected: updateCategory,
        ),
        direction: PopoverDirection.bottom,
        width: 200,
        height: 150,
        arrowHeight: 10,
        arrowWidth: 20,
      ),
      child: Container(
        padding: widget.isEditPage
            ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2) // Padding untuk halaman edit
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding default
        decoration: BoxDecoration(
          color: widget.isEditPage
              ? const Color(0xFFB3C8CF) // Warna untuk halaman edit
              : const Color(0xFFD9D9D9), // Warna default (abu-abu muda)
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedCategory,
              style: GoogleFonts.poppins(
                fontSize: widget.isEditPage ? 12 : 12, // Ukuran font
                fontWeight: FontWeight.w500,
                color: const Color(0xFF222831),
              ),
            ),
            if (widget.isEditPage) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_drop_down,
                size: 16,
                color: Color(0xFF222831),
              ),
            ],
          ],
        ),
      ),
    );
  }
}