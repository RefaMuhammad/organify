import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:google_fonts/google_fonts.dart';
import 'category_menu.dart';

class CategoryButton extends StatefulWidget {
  final bool isEditPage; // Tambahkan flag untuk halaman edit
  const CategoryButton({super.key, this.isEditPage = false}); // Default false

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  String selectedCategory = 'Pribadi'; // Kategori default

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
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
            ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2) // Halaman edit
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Default
        decoration: BoxDecoration(
          color: widget.isEditPage
              ? const Color(0xFFB3C8CF) // Halaman edit
              : const Color(0xFFD9D9D9), // Default warna abu-abu muda
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedCategory,
              style: GoogleFonts.poppins(
                fontSize: widget.isEditPage ? 12 : 12, // Font lebih besar di edit
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
