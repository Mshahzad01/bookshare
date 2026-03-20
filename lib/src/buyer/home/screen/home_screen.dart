import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../models/book.dart';
import '../../../../models/banner_item.dart';
import '../../../../models/business.dart';
import '../cubit/buyer_home_cubit.dart';
import '../cubit/buyer_home_state.dart';
import 'widgets/shimmer_loading.dart';
import 'book_detail_screen.dart';
import '../../cart/cubit/cart_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  
  // Dummy banners for the top
  final List<BannerItem> _banners = [
    BannerItem(id: '1', title: 'Welcome to BookShare', subtitle: 'Find the best books near you', imageUrl: 'assets/images/banner1.jpg'),
    BannerItem(id: '2', title: 'Donate & Help', subtitle: 'Give your old books a new life', imageUrl: 'assets/images/banner2.jpg'),
    BannerItem(id: '3', title: 'Top Rated Sellers', subtitle: 'Discover amazing stores today', imageUrl: 'assets/images/banner3.jpg'),
  ];

  @override
  void initState() {
    super.initState();
    context.read<BuyerHomeCubit>().fetchHomeData();
    Future.delayed(Duration.zero, () {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (_bannerController.hasClients && mounted) {
        final nextPage = (_bannerController.page ?? 0).toInt() + 1;
        _bannerController.animateToPage(
          nextPage % _banners.length,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        ).then((_) => _startAutoScroll());
      }
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyerHomeCubit, BuyerHomeState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            // SliverAppBar with location
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              expandedHeight: 70,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SafeArea(
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Current Location',
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                              ),
                              Text(
                                'Islamabad, Pakistan', // Dummy location for now
                                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Banner Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _buildBannerCarousel(_banners),
              ),
            ),

            // Content Area based on State
            if (state is BuyerHomeLoading) ...[
              SliverToBoxAdapter(child: _buildShimmerSection('Categories', 50, 100)),
              SliverToBoxAdapter(child: _buildShimmerSection('Donate Books', 220, 160)),
              SliverToBoxAdapter(child: _buildShimmerSection('Stores', 120, 120)),
              SliverToBoxAdapter(child: _buildShimmerSection('Books Nearby', 220, 160)),
            ] else if (state is BuyerHomeError) ...[
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text('Failed to load: ${state.message}', style: const TextStyle(color: Colors.red)),
                  ),
                ),
              ),
            ] else if (state is BuyerHomeLoaded) ...[
              // Categories Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Categories', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _buildCategoriesList(state.categories),
                    ],
                  ),
                ),
              ),

              // Donate Books Section
              if (state.donateBooks.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Row(
                      children: [
                        Icon(Icons.volunteer_activism, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text('Donate Books', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        TextButton(onPressed: () {}, child: const Text('See All')),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.donateBooks.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _buildBookCard(context, state.donateBooks[index]),
                        );
                      },
                    ),
                  ),
                ),
              ],

              // Stores Section
              if (state.stores.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Row(
                      children: [
                        Icon(Icons.storefront, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text('Stores Nearby', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.stores.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _buildStoreCard(context, state.stores[index]),
                        );
                      },
                    ),
                  ),
                ),
              ],

              // Books Nearby Section
              if (state.allBooks.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Row(
                      children: [
                        Icon(Icons.location_searching, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text('Books Nearby', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.60,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildBookCard(context, state.allBooks[index]);
                      },
                      childCount: state.allBooks.length,
                    ),
                  ),
                ),
              ] else ...[
                 SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(child: Text("No Books found yet, check back later!", style: GoogleFonts.poppins())),
                    ),
                 ),
              ],

              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildShimmerSection(String title, double height, double width) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerEffect(width: 150, height: 24, borderRadius: 4),
          const SizedBox(height: 16),
          SizedBox(
            height: height,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ShimmerEffect(width: width, height: height, borderRadius: 16),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel(List<BannerItem> banners) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.primary, // Fallback color since image might missing
                  image: const DecorationImage(
                    image: AssetImage('assets/images/banner1.jpg'), // using generic block if missing
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        banner.title,
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        banner.subtitle,
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _bannerController,
          count: banners.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Theme.of(context).colorScheme.primary,
            dotColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesList(List<String> categories) {
    if (categories.isEmpty) return const Text('No categories heavily populated yet.');
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Icon(Icons.category, size: 20, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        categories[index],
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
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
  }

  Widget _buildStoreCard(BuildContext context, Business business) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(16),
         border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: (business.logoUrl != null && business.logoUrl!.isNotEmpty)
                ? NetworkImage(business.logoUrl!)
                : null,
            child: (business.logoUrl == null || business.logoUrl!.isEmpty)
                ? const Icon(Icons.store, size: 30) : null,
          ),
          const SizedBox(height: 8),
          Text(
            business.businessName,
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
            maxLines: 1, 
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            business.businessType,
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
          ),
        ],
      )
    );
  }

  Widget _buildBookCard(BuildContext context, Book book) {
    return GestureDetector(
      onTap: () {
        final cartCubit = context.read<CartCubit>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: cartCubit,
              child: BookDetailScreen(book: book),
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Book Image with Badge
            Stack(
              children: [
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    color: Colors.grey.shade200,
                    image: DecorationImage(
                      image: book.imageUrl.startsWith('http') 
                          ? NetworkImage(book.imageUrl) as ImageProvider
                          : AssetImage('assets/images/book_placeholder.jpg'), // fallback
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (book.isDonation)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'FREE',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Book Details
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    book.title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    book.author.isNotEmpty ? book.author : 'Unknown Author',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          book.location.isNotEmpty ? book.location : 'Online',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (!book.isDonation)
                    Text(
                      'Rs. ${book.price?.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  else
                    Text(
                      'DONATE',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
