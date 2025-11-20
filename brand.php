<?php
require_once 'config/database.php';

$database = new Database();
$db = $database->getConnection();

// Lấy ID brand từ URL
$brandId = $_GET['id'] ?? null;
if (!$brandId) {
    redirectTo('index.php');
}

// Lấy thông tin brand
$stmt = $db->prepare("
SELECT 
    b.*,
    AVG(c.rating) AS average_rating,
    COUNT(c.id) AS total_comments,
    COUNT(CASE WHEN c.rating = 1 THEN 1 END) AS total_1_star_comments,
    COUNT(CASE WHEN c.rating = 2 THEN 2 END) AS total_2_star_comments,
    COUNT(CASE WHEN c.rating = 3 THEN 3 END) AS total_3_star_comments,
    COUNT(CASE WHEN c.rating = 4 THEN 4 END) AS total_4_star_comments,
    COUNT(CASE WHEN c.rating = 5 THEN 5 END) AS total_5_star_comments
FROM brands b
LEFT JOIN comments c ON c.brand_id = b.id
WHERE b.id = ? 
");
$stmt->execute([$brandId]);
$brand = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$brand) {
    redirectTo('index.php');
}
// xử lý thông báo sucess
$successMessage = '';
if (isset($_SESSION['success_message'])) {
    $successMessage = $_SESSION['success_message'];
    unset($_SESSION['success_message']);
}


// Xử lý xóa bình luận và rating nếu là comment gốc
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['delete_comment_id']) && isLoggedIn()) {
    $commentId = (int)$_POST['delete_comment_id'];
    $userId = getCurrentUserId();

    $stmt = $db->prepare("SELECT parent_id FROM comments WHERE id = ? AND user_id = ?");
    $stmt->execute([$commentId, $userId]);
    $commentInfo = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($commentInfo) {
        try {
            $stmt = $db->prepare("UPDATE comments SET is_hidden = 1 WHERE id = ? AND user_id = ?");
            $stmt->execute([$commentId, $userId]);

            // if (is_null($commentInfo['parent_id'])) {
            //     $stmt = $db->prepare("DELETE FROM ratings WHERE user_id = ? AND brand_id = ?");
            //     $stmt->execute([$userId, $brandId]);

            //     $avgStmt = $db->prepare("
            //         UPDATE brands 
            //         SET average_rating = (SELECT AVG(rating) FROM ratings WHERE brand_id = ?),
            //             total_ratings = (SELECT COUNT(*) FROM ratings WHERE brand_id = ?)
            //         WHERE id = ?
            //     ");
            //     $avgStmt->execute([$brandId, $brandId, $brandId]);
            // }

            $_SESSION['success'] = 'Bình luận đã được xóa!';
        } catch (Exception $e) {
            $_SESSION['error'] = 'Có lỗi xảy ra khi xóa bình luận!';
        }
    } else {
        $_SESSION['error'] = 'Không tìm thấy bình luận hoặc không có quyền.';
    }
    redirectTo("brand.php?id=$brandId");
    exit;
}

// Lấy đánh giá user hiện tại
$userRating = 0;
if (isLoggedIn()) {
    $stmt = $db->prepare("SELECT AVG(rating) FROM comments WHERE user_id = ? AND brand_id = ?");
    $stmt->execute([getCurrentUserId(), $brandId]);
    $userRating = $stmt->fetchColumn();
    $userRating = ($userRating !== false && $userRating !== null) ? (int)$userRating : 0;
}

// Lấy danh sách comment
// $stmt = $db->prepare("
//   SELECT c.id, c.user_id, c.brand_id, c.product_id, c.parent_id, c.content, c.image, c.created_at, 
//          u.username, u.avatar,
//          (SELECT rating FROM ratings r WHERE r.user_id = c.user_id AND r.brand_id = c.brand_id LIMIT 1) as user_rating
//     FROM comments c 
//     JOIN users u ON c.user_id = u.id 
//     WHERE c.brand_id = ? 
//       AND c.parent_id IS NULL 
//       AND c.is_hidden = 0
//     ORDER BY c.created_at DESC, c.id DESC
// ");
// $stmt->execute([$brandId]);
// $comments = $stmt->fetchAll(PDO::FETCH_ASSOC);

// // Lấy các replies
// foreach ($comments as &$comment) {
//     $stmt = $db->prepare("SELECT c.id, c.user_id, c.brand_id, c.product_id, c.parent_id, c.content, c.image, c.created_at, u.username, u.avatar FROM comments c JOIN users u ON c.user_id = u.id WHERE c.parent_id = ? AND c.is_hidden = 0 ORDER BY c.created_at ASC");
//     $stmt->execute([$comment['id']]);
//     $comment['replies'] = $stmt->fetchAll(PDO::FETCH_ASSOC);
// }
// unset($comment); // <-- quan trọng: giải phóng tham chiếu để tránh lỗi hiển thị lặp nội dung

// --- Lấy danh sách products của brand (không lấy comment ở cấp brand) ---
$stmt = $db->prepare("
  SELECT 
    p.*,
    IFNULL(AVG(c.rating), 0) AS average_rating,
    COUNT(c.id) AS total_ratings
FROM products p
LEFT JOIN comments c ON c.product_id = p.id
WHERE p.brand_id = ?
GROUP BY p.id
ORDER BY p.created_at DESC;
");
$stmt->execute([$brandId]);
$products = $stmt->fetchAll(PDO::FETCH_ASSOC);

// --- Bỏ việc tải comments/replies cho từng product để không hiển thị bình luận trên brand.php ---

// --- Tính phân bố đánh giá: dùng tổng sao của từng tài khoản (sum per user) ---
// $ratingDistribution = array_fill(1, 5, 0);
// $brand_total_stars = 0;
// $brand_total_ratings = 0; // số tài khoản đã đánh
// $brand_avg_rating = 0;

// kiểm tra bảng tồn tại
// $tableCheck = $db->prepare("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = ?");
// $tableCheck->execute(['products']);
// $hasProducts = $tableCheck->fetchColumn() > 0;
// $tableCheck->execute(['product_ratings']);
// $hasProductRatings = $tableCheck->fetchColumn() > 0;

// if ($hasProducts && $hasProductRatings) {
//     // Lấy tổng sao theo từng user (tổng rating user cho tất cả product thuộc brand)
//     $stmt = $db->prepare("
//         SELECT pr.user_id, SUM(pr.rating) AS user_total_stars, COUNT(*) AS user_rating_count
//         FROM product_ratings pr
//         JOIN products p ON pr.product_id = p.id
//         WHERE p.brand_id = ?
//         GROUP BY pr.user_id
//     ");
//     $stmt->execute([$brandId]);
//     $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

//     foreach ($rows as $r) {
//         $user_total = (int)$r['user_total_stars'];      // tổng số sao user đã cho (có thể >5)
//         $brand_total_stars += $user_total;              // cộng vào tổng sao của brand
//         $brand_total_ratings++;                         // 1 user = 1 đóng góp cho tổng số tài khoản đánh

//         // Nếu vẫn muốn hiển thị phân bố 1..5, bạn có thể map user_total vào bucket 1..5 (ví dụ cap tối đa 5)
//         $bucket = max(1, min(5, $user_total)); // cap vào 1..5
//         $ratingDistribution[$bucket]++;
//     }

//     if ($brand_total_ratings > 0) {
//         // trung bình = tổng sao / số tài khoản đã đánh
//         $brand_avg_rating = $brand_total_stars / $brand_total_ratings;
//     }
// }

// Gán lại để phần hiển thị dùng biến cũ vẫn hoạt động
// $brand['average_rating'] = $brand_avg_rating;
// $brand['total_ratings'] = $brand_total_ratings;
// $brand['total_stars'] = $brand_total_stars;
?>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars($brand['name']) ?> - Fashion Review</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #e91e63;
            --secondary-color: #f06292;
            --accent-color: #ffc107;
            --text-muted: #6c757d;
        }

        .brand-header {
            position: relative;
            background: linear-gradient(135deg, rgba(233, 30, 99, 0.9), rgba(240, 98, 146, 0.8)), 
                        url('uploads/brands/<?= $brand['cover_image'] ?: 'default-brand.jpg' ?>');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            color: white;
            padding: 120px 0 80px;
            overflow: hidden;
        }

        .brand-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.3);
            z-index: 1;
        }

        .brand-header .container {
            position: relative;
            z-index: 2;
        }

        .rating-stars {
            color: var(--accent-color);
            font-size: 1.5rem;
            text-shadow: 0 0 10px rgba(255, 193, 7, 0.5);
        }

        .rating-interactive {
            display: flex;
            gap: 5px;
            justify-content: center;
            margin: 15px 0;
        }

        .rating-interactive .star {
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 2rem;
            color: #ddd;
            text-shadow: 0 0 5px rgba(0,0,0,0.3);
        }

        .rating-interactive .star:hover,
        .rating-interactive .star.active {
            color: var(--accent-color);
            transform: scale(1.2);
            text-shadow: 0 0 15px rgba(255, 193, 7, 0.8);
        }

        .comment-rating {
            display: flex;
            gap: 3px;
            margin: 10px 0;
        }

        .comment-rating .star {
            cursor: pointer;
            transition: all 0.2s ease;
            color: #ddd;
            font-size: 1.2rem;
        }

        .comment-rating .star:hover,
        .comment-rating .star.active {
            color: var(--accent-color);
            transform: scale(1.1);
        }

        .brand-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border: none;
            transition: all 0.3s ease;
        }

        .brand-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .comment-card {
            background: white;
            border-radius: 15px;
            border: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            transition: all 0.3s ease;
            border-left: 4px solid var(--primary-color);
        }

        .comment-card:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
            transform: translateY(-2px);
        }

        .reply-card {
            background: #f8f9fa;
            border-radius: 12px;
            border: none;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            margin-left: 20px;
            margin-bottom: 10px;
            border-left: 4px solid #2196f3;
        }

        .avatar {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border: 3px solid white;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        }

        .reply-avatar {
            width: 35px;
            height: 35px;
            object-fit: cover;
            border: 2px solid white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }

        .external-links .btn {
            border-radius: 25px;
            padding: 10px 20px;
            margin: 5px;
            transition: all 0.3s ease;
        }

        .external-links .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .navbar {
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.95) !important;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            border-radius: 25px;
            padding: 10px 25px;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #c2185b, var(--primary-color));
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(233, 30, 99, 0.4);
        }

        .rating-distribution {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin: 20px 0;
        }

        .rating-bar {
            height: 8px;
            background: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
            margin: 5px 0;
        }

        .rating-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--accent-color), #ffeb3b);
            transition: width 0.3s ease;
        }

        .brand-stats {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin: 20px 0;
        }

        .stat-item {
            text-align: center;
            padding: 15px;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: var(--accent-color);
        }

        .comment-meta {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 10px 15px;
            margin-bottom: 15px;
            border-left: 4px solid var(--primary-color);
        }

        .user-rating-display {
            display: inline-flex;
            align-items: center;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            margin-left: 10px;
        }

        .comment-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .comment-actions .btn {
            border-radius: 20px;
            padding: 5px 15px;
            font-size: 0.9rem;
        }

        .image-gallery {
            display: flex;
            gap: 10px;
            margin: 15px 0;
            flex-wrap: wrap;
        }

        .comment-image {
            max-height: 200px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
        }

        .comment-image:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 20px rgba(0,0,0,0.3);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--text-muted);
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--primary-color);
            margin-bottom: 20px;
            opacity: 0.7;
        }

        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        @media (max-width: 768px) {
            .brand-header {
                padding: 80px 0 60px;
                background-attachment: scroll;
            }
            
            .rating-interactive .star {
                font-size: 1.5rem;
            }
            
            .comment-card {
                margin-left: 0;
            }
            
            .reply-card {
                margin-left: 10px;
            }
        }
        .btn-pink {
    background: #e91e63;
    color: #fff;
    font-weight: 600;
    padding: 15px 25px;
    border-radius: 30px;
    border: none;
    transition: 0.25s ease;
}

.btn-pink:hover {
    background: #d11656;
    color: #fff;
}
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light sticky-top">
        <div class="container">
            <a class="navbar-brand fw-bold text-primary" href="index.php">
                <i class="fas fa-heart me-2"></i>Fashion Review
            </a>
            <div class="navbar-nav ms-auto">
                <a href="index.php" class="btn btn-outline-secondary rounded-pill">
                    <i class="fas fa-arrow-left me-2"></i>Về trang chủ
                </a>
            </div>
        </div>
    </nav>

    <!-- Success/Error Messages -->
    <?php if (isset($_SESSION['success'])): ?>
        <div class="container mt-3">
            <div class="alert alert-success alert-dismissible fade show fade-in" role="alert">
                <i class="fas fa-check-circle me-2"></i><?= $_SESSION['success'] ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </div>
        <?php unset($_SESSION['success']); ?>
    <?php endif; ?>

    <?php if (isset($_SESSION['error'])): ?>
        <div class="container mt-3">
            <div class="alert alert-danger alert-dismissible fade show fade-in" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i><?= $_SESSION['error'] ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </div>
        <?php unset($_SESSION['error']); ?>
    <?php endif; ?>

    <!-- Brand Header -->
    <section class="brand-header text-center">
        <div class="container">
            <h1 class="display-4 mb-4 fade-in">
                <i class="fas fa-crown me-3"></i>
                <?= htmlspecialchars($brand['name']) ?>
            </h1>
            
            <div class="rating-stars mb-4 fade-in">
                <?php
                $rating = round($brand['average_rating']);
                for ($i = 1; $i <= 5; $i++) {
                    echo $i <= $rating ? '<i class="fas fa-star"></i>' : '<i class="far fa-star"></i>';
                }
                ?>
                <span class="ms-3 fs-5"><?= number_format($brand['average_rating'], 1) ?>/5</span>
                <span class="ms-2 opacity-75">(<?= $brand['total_comments'] ?> đánh giá)</span>
            </div>
            
            <p class="lead mb-4 fade-in"><?= htmlspecialchars($brand['description']) ?></p>
            
            <div class="brand-stats fade-in">
                <div class="row">
                    <div class="col-md-6 stat-item">
                        <div class="stat-number">
                            <i class="fas fa-tags me-2"></i>
                            <?= number_format($brand['price_range_min']) ?>đ - <?= number_format($brand['price_range_max']) ?>đ
                        </div>
                        <div>Khoảng giá</div>
                    </div>
                    <div class="col-md-6 stat-item">
                        <div class="stat-number">
                            <i class="fas fa-calendar-alt me-2"></i>
                            <?= date('d/m/Y', strtotime($brand['created_at'])) ?>
                        </div>
                        <div>Ngày thêm</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Brand Content -->
    <div class="container my-5">
        <div class="row">
            <!-- Left Column - Brand Info & Quick Rating -->
            <div class="col-lg-4">
                <div class="brand-card mb-4 fade-in">
                    <div class="card-body text-center">
                        <?php if ($brand['cover_image'] && file_exists("uploads/brands/" . $brand['cover_image'])): ?>
                            <img src="uploads/brands/<?= htmlspecialchars($brand['cover_image']) ?>" 
                                 class="img-fluid rounded-3 mb-4" style="max-height: 250px;" 
                                 alt="<?= htmlspecialchars($brand['name']) ?>">
                        <?php else: ?>
                            <div class="bg-light rounded-3 d-flex align-items-center justify-content-center mb-4" style="height: 200px;">
                                <i class="fas fa-store fa-4x text-muted"></i>
                            </div>
                        <?php endif; ?>
                        
                        <!-- External Links -->
                        <div class="external-links mb-4">
                            <?php if ($brand['shopee_link']): ?>
                                <a href="<?= htmlspecialchars($brand['shopee_link']) ?>" 
                                   class="btn btn-warning" target="_blank">
                                    <i class="fas fa-shopping-cart me-2"></i>Mua trên Shopee
                                </a>
                            <?php endif; ?>
                            
                            <?php if ($brand['facebook_link']): ?>
                                <a href="<?= htmlspecialchars($brand['facebook_link']) ?>" 
                                   class="btn btn-primary" target="_blank">
                                    <i class="fab fa-facebook-f me-2"></i>Facebook
                                </a>
                            <?php endif; ?>
                        </div>

                        <!-- Quick Rating -->
                        <?php if (isLoggedIn()): ?>
                            <div class="comment-meta">
                                <h6><i class="fas fa-star me-2"></i>Số sao bạn đánh giá</h6>
                                <form method="POST" class="rating-form">
                                    <input type="hidden" name="rating" id="ratingInput" value="<?= htmlspecialchars($userRating) ?>">
                                    <div class="rating-interactive" aria-label="Đánh giá của bạn">
                                        <?php for ($i = 1; $i <= 5; $i++): ?>
                                            <i class="fas fa-star star <?= ($i <= $userRating) ? 'active' : '' ?>" 
                                               data-rating="<?= $i ?>" title="<?= $i ?> sao"></i>
                                        <?php endfor; ?>
                                    </div>
                                </form>
                            </div>
                        <?php endif; ?>
                        <!-- Nút Thử dáng -->
                        <a href="stylist.php?brand_id=<?= $brand['id'] ?>" 
                            class="btn btn-pink w-100 mt-3">
                            <i class="fas fa-user me-2"></i>Thử dáng với thương hiệu này
                            </a>
                        <!-- Rating Distribution -->
                        <div class="rating-distribution">
                            <h6 class="mb-3"><i class="fas fa-chart-bar me-2"></i>Phân bố đánh giá</h6>
                            <?php 
                            for ($i = 5; $i >= 1; $i--): 
                                $key = 'total_' . $i . '_star_comments';
                                $count = $brand[$key] ?? 0;
                                $percentage = $brand['total_comments'] > 0 ? ($count / $brand['total_comments']) * 100 : 0;
                            ?>
                                <div class="d-flex align-items-center mb-2">
                                    <span class="me-2"><?= $i ?>⭐</span>
                                    <div class="rating-bar flex-grow-1 me-2">
                                        <div class="rating-fill" style="width: <?= $percentage ?>%"></div>
                                    </div>
                                    <span class="text-muted small"><?= $count ?></span>
                                </div>
                            <?php endfor; ?>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column - Comments with Rating -->
            <div class="col-lg-8">
                <!-- Replace brand-level comment form/list with a notice pointing to product pages -->
                <div class="container my-4">
                    <div class="card mb-4">
                        <div class="card-body d-flex justify-content-between align-items-start">
                            <div>
                                <h4 class="mb-1"><?= htmlspecialchars($brand['name']) ?></h4>
                                <?php if (!empty($brand['description'])): ?>
                                    <p class="text-muted mb-1"><?= htmlspecialchars($brand['description']) ?></p>
                                <?php endif; ?>
                            <div class="text-end">
                                <?php if ((function_exists('isAdmin') && isAdmin()) || (function_exists('isBrandOwner') && isBrandOwner($brandId))): ?>
                                    <a href="admin.php?tab=products&brand_id=<?= $brandId ?>" class="btn btn-primary btn-sm">
                                        <i class="fas fa-plus-circle me-1"></i>Thêm sản phẩm
                                    </a>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>

                    <!-- Notice: comments handled on product pages -->
                    <div class="row mb-3">
                        <div class="col-12">
                            <div class="alert alert-info mb-0">
                                Bình luận và đánh giá được thực hiện trên trang chi tiết từng sản phẩm.
                                Vui lòng bấm "Xem" trên sản phẩm để chuyển tới trang sản phẩm và bình luận/đánh giá.
                            </div>
                        </div>
                    </div>

                    <!-- Products list (unchanged) -->
                    <div class="row g-3">
                        <?php if (empty($products)): ?>
                            <div class="col-12">
                                <div class="alert alert-secondary mb-0">Chưa có sản phẩm nào thuộc thương hiệu này.</div>
                            </div>
                        <?php else: ?>
                            <?php foreach ($products as $p): ?>
                                <?php $img = !empty($p['image']) && file_exists(__DIR__.'/uploads/products/'.$p['image']) ? $p['image'] : 'default-product.jpg'; ?>
                                <div class="col-md-6 col-lg-4">
                                    <div class="card h-100">
                                        <img src="uploads/products/<?= htmlspecialchars($img) ?>" class="card-img-top" style="height:180px;object-fit:cover;" alt="<?= htmlspecialchars($p['name']) ?>">
                                        <div class="card-body d-flex flex-column">
                                            <h6 class="card-title mb-1"><?= htmlspecialchars($p['name']) ?></h6>
                                            <p class="text-muted small mb-2"><?= htmlspecialchars($p['short_description'] ?? '') ?></p>
                                            <div class="mt-auto d-flex justify-content-between align-items-center">
                                                <div>
                                                    <div class="fw-bold text-primary"><?= number_format($p['price'] ?? 0) ?>đ</div>
                                                    <div class="small text-muted">
                                                        <i class="fas fa-star text-warning me-1"></i><?= number_format($p['average_rating'] ?? 0, 1) ?> /5 (<?= $p['total_ratings'] ?? 0 ?>)
                                                    </div>
                                                </div>
                                                <div>
                                                    <a href="product.php?id=<?= $p['id'] ?>" class="btn btn-sm btn-outline-primary">Xem</a>
                                                    <?php if (function_exists('isAdmin') && isAdmin()): ?>
                                                        <a href="admin.php?tab=products&edit_product=<?= $p['id'] ?>" class="btn btn-sm btn-outline-secondary ms-1">Sửa</a>
                                                    <?php endif; ?>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Products list (no comments on brand page) -->
    <!-- (Đã loại bỏ phần hiển thị sản phẩm lặp ở dưới. Sản phẩm vẫn hiển thị trong phần chính ở trên.) -->
    <!-- end products -->

    <!-- Related Brands Section -->
    <section class="py-5 bg-light">
        <div class="container">
            <h3 class="text-center mb-5">
                <i class="fas fa-heart me-2"></i>Có thể bạn quan tâm
            </h3>
            
            <div class="row">
                <?php
                // Lấy các brand liên quan (cùng khoảng giá hoặc rating cao)
                $stmt = $db->prepare("
    SELECT 
        b.*,
        AVG(c.rating) AS average_rating,
        COUNT(c.id) AS total_comments
    FROM brands b
    LEFT JOIN comments c ON c.brand_id = b.id
    WHERE b.id != ?  -- Giữ lại điều kiện lọc cơ bản (không phải brand hiện tại)
    GROUP By b.id
    HAVING (             -- 👈 SỬ DỤNG HAVING Ở ĐÂY
        (b.price_range_min BETWEEN ? AND ?) OR 
        (b.price_range_max BETWEEN ? AND ?) OR
        average_rating >= 4
    )
    ORDER BY average_rating DESC, total_comments DESC
    LIMIT 4 
");
                $stmt->execute([
                    $brandId, 
                    $brand['price_range_min'] * 0.8, $brand['price_range_max'] * 1.2,
                    $brand['price_range_min'] * 0.8, $brand['price_range_max'] * 1.2
                ]);
                $relatedBrands = $stmt->fetchAll(PDO::FETCH_ASSOC);
                ?>
                
                <?php foreach ($relatedBrands as $relatedBrand): ?>
                    <div class="col-md-6 col-lg-3 mb-4">
                        <div class="card brand-card h-100">
                            <div class="position-relative">
                                <?php if ($relatedBrand['cover_image'] && file_exists("uploads/brands/" . $relatedBrand['cover_image'])): ?>
                                    <img src="uploads/brands/<?= htmlspecialchars($relatedBrand['cover_image']) ?>" 
                                         class="card-img-top" style="height: 150px; object-fit: cover;" 
                                         alt="<?= htmlspecialchars($relatedBrand['name']) ?>">
                                <?php else: ?>
                                    <div class="card-img-top bg-light d-flex align-items-center justify-content-center" style="height: 150px;">
                                        <i class="fas fa-store fa-2x text-muted"></i>
                                    </div>
                                <?php endif; ?>
                            </div>
                            
                            <div class="card-body">
                                <h6 class="card-title"><?= htmlspecialchars($relatedBrand['name']) ?></h6>
                                
                                <div class="rating-stars mb-2" style="font-size: 1rem;">
                                    <?php
                                    $relatedRating = round($relatedBrand['average_rating']);
                                    for ($i = 1; $i <= 5; $i++) {
                                        echo $i <= $relatedRating ? '<i class="fas fa-star"></i>' : '<i class="far fa-star"></i>';
                                    }
                                    ?>
                                    <small class="text-muted ms-1">(<?= $relatedBrand['total_comments'] ?>)</small>
                                </div>
                                
                                <p class="text-primary fw-bold mb-3" style="font-size: 0.9rem;">
                                    <?= number_format($relatedBrand['price_range_min']) ?>đ - <?= number_format($relatedBrand['price_range_max']) ?>đ
                                </p>
                                
                                <a href="brand.php?id=<?= $relatedBrand['id'] ?>" class="btn btn-outline-primary btn-sm w-100">
                                    <i class="fas fa-eye me-1"></i>Xem chi tiết
                                </a>
                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
    </section>

    <!-- Image Modal -->
    <div class="modal fade" id="imageModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0">
                <div class="modal-header border-0">
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center p-0">
                    <img id="modalImage" src="" class="img-fluid w-100" alt="Full size image">
                </div>
            </div>
        </div>
    </div>
    <!-- Back to Top Button -->
    <button class="btn btn-primary rounded-circle position-fixed bottom-0 end-0 m-4" 
            id="backToTop" style="width: 50px; height: 50px; display: none; z-index: 1000;">
        <i class="fas fa-arrow-up"></i>
    </button>
<?php if (!empty($successMessage)): ?>
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999">
    <div id="toastSuccess" class="toast align-items-center text-bg-success border-0 show" role="alert">
        <div class="d-flex">
            <div class="toast-body">
                <?= htmlspecialchars($successMessage) ?>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Đóng"></button>
        </div>
    </div>
</div>
<?php endif; ?>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Quick Rating interaction
        document.querySelectorAll('.rating-interactive .star').forEach(star => {
            star.addEventListener('click', function() {
                const rating = this.dataset.rating;
                document.getElementById('ratingInput').value = rating;
                
                // Update visual feedback
                document.querySelectorAll('.rating-interactive .star').forEach((s, index) => {
                    if (index < rating) {
                        s.classList.add('active');
                    } else {
                        s.classList.remove('active');
                    }
                });
            });
        });

        // Comment Rating interaction
        document.querySelectorAll('#commentRating .star').forEach(star => {
            star.addEventListener('click', function() {
                const rating = this.dataset.rating;
                document.getElementById('commentRatingInput').value = rating;
                
                // Update visual feedback
                document.querySelectorAll('#commentRating .star').forEach((s, index) => {
                    if (index < rating) {
                        s.classList.add('active');
                    } else {
                        s.classList.remove('active');
                    }
                });
            });
        });

        // Reply functionality
        document.querySelectorAll('.reply-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const commentId = this.dataset.commentId;
                const replyForm = document.getElementById(`reply-form-${commentId}`);
                
                // Hide all other reply forms
                document.querySelectorAll('.reply-form').forEach(form => {
                    if (form.id !== `reply-form-${commentId}`) {
                        form.style.display = 'none';
                    }
                });
                
                // Toggle current reply form
                replyForm.style.display = replyForm.style.display === 'none' ? 'block' : 'none';
                
                // Focus on textarea if shown
                if (replyForm.style.display === 'block') {
                    replyForm.querySelector('textarea').focus();
                }
            });
        });

        document.querySelectorAll('.cancel-reply').forEach(btn => {
            btn.addEventListener('click', function() {
                this.closest('.reply-form').style.display = 'none';
            });
        });

        // Image modal
        function openImageModal(src) {
            document.getElementById('modalImage').src = src;
            new bootstrap.Modal(document.getElementById('imageModal')).show();
        }

        // Auto hide alerts
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
                if (bsAlert) bsAlert.close();
            });
        }, 5000);

        // Back to top button
        const backToTopBtn = document.getElementById('backToTop');
        
        window.addEventListener('scroll', function() {
            if (window.pageYOffset > 300) {
                backToTopBtn.style.display = 'block';
            } else {
                backToTopBtn.style.display = 'none';
            }
        });

        backToTopBtn.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });

        // Smooth scroll animation observer
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('fade-in');
                }
            });
        }, observerOptions);

        // xem tất cả các thẻ cmt
        document.querySelectorAll('.comment-card, .reply-card').forEach(card => {
            observer.observe(card);
        });

        // Add hover effects
        document.querySelectorAll('.comment-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.borderLeftColor = '#f06292';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.borderLeftColor = '#e91e63';
            });
        });

        // Star hover effects for rating displays
        document.querySelectorAll('.rating-interactive, .comment-rating').forEach(ratingContainer => {
            const stars = ratingContainer.querySelectorAll('.star');
            
            stars.forEach((star, index) => {
                star.addEventListener('mouseenter', function() {
                    stars.forEach((s, i) => {
                        if (i <= index) {
                            s.style.color = '#ffc107';
                            s.style.transform = 'scale(1.1)';
                        } else {
                            s.style.color = '#ddd';
                            s.style.transform = 'scale(1)';
                        }
                    });
                });
            });
            
            ratingContainer.addEventListener('mouseleave', function() {
                stars.forEach(star => {
                    if (star.classList.contains('active')) {
                        star.style.color = '#ffc107';
                        star.style.transform = 'scale(1.2)';
                    } else {
                        star.style.color = '#ddd';
                        star.style.transform = 'scale(1)';
                    }
                });
            });
        });
        
    </script>
    <script>
document.addEventListener('DOMContentLoaded', function () {
    const msgEl = document.getElementById('js-success-message');
    if (msgEl) {
        const message = msgEl.getAttribute('data-message');
        alert(message); // hoặc bạn có thể thay bằng SweetAlert2 nếu muốn đẹp
    }
});
</script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    var toastEl = document.getElementById('toastSuccess');
    if (toastEl) {
        var toast = new bootstrap.Toast(toastEl, { delay: 4000 });
        toast.show();
    }
});
</script>

</body>
</html>