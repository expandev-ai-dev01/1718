export interface ProductSummary {
  idProduct: number;
  name: string;
  mainImageUrl: string;
  price: number;
  originalPrice: number | null;
  averageRating: number;
  reviewCount: number;
  confectionerName: string;
  isAvailable: boolean;
  preparationTime: string;
}

export interface Pagination {
  page: number;
  pageSize: number;
  totalRecords: number;
  totalPages: number;
}

export interface ProductListResponse {
  products: ProductSummary[];
  pagination: Pagination;
}

export interface ProductListParams {
  idAccount: number;
  pageNumber: number;
  pageSize: number;
  sortBy?: string;
  searchTerm?: string;
  categoryIds?: string; // JSON array as string
  flavorIds?: string;
  sizeIds?: string;
  confectionerIds?: string;
  minPrice?: number;
  maxPrice?: number;
}

export interface ProductImage {
  imageUrl: string;
  displayOrder: number;
}

export interface ProductFlavor {
  idFlavor: number;
  name: string;
}

export interface ProductSize {
  idSize: number;
  name: string;
  description: string;
  priceModifier: number;
}

export interface ProductReview {
  idProductReview: number;
  customerName: string;
  rating: number;
  comment: string | null;
  dateCreated: Date;
}

export interface ConfectionerInfo {
  idConfectioner: number;
  name: string;
  profilePictureUrl: string | null;
  averageRating: number;
  productsSold: number;
}

export interface ProductDetail {
  idProduct: number;
  name: string;
  description: string;
  ingredients: string;
  basePrice: number;
  promotionalPrice: number | null;
  averageRating: number;
  reviewCount: number;
  isAvailable: boolean;
  preparationTime: string;
  images: ProductImage[];
  availableFlavors: ProductFlavor[];
  availableSizes: ProductSize[];
  reviews: ProductReview[];
  confectioner: ConfectionerInfo;
}

export interface RelatedProduct {
  idProduct: number;
  name: string;
  mainImageUrl: string;
  price: number;
  averageRating: number;
}

export interface FilterOption {
  id: number;
  name: string;
}

export interface SizeFilterOption {
  idSize: number;
  name: string;
  description: string;
}

export interface FilterOptions {
  categories: FilterOption[];
  flavors: FilterOption[];
  sizes: SizeFilterOption[];
  confectioners: FilterOption[];
}
