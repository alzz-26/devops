package com.devops.inventory.controller;

import com.devops.inventory.model.Product;
import com.devops.inventory.service.ProductService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/products")
@Slf4j
@Tag(name = "Product Management", description = "APIs for managing inventory products")
public class ProductController {
    
    private final ProductService productService;
    
    @Autowired
    public ProductController(ProductService productService) {
        this.productService = productService;
    }
    
    @GetMapping
    @Operation(summary = "Get all products", description = "Retrieve a list of all products in the inventory")
    public ResponseEntity<List<Product>> getAllProducts() {
        log.info("GET /api/products - Fetching all products");
        List<Product> products = productService.getAllProducts();
        return ResponseEntity.ok(products);
    }
    
    @GetMapping("/{id}")
    @Operation(summary = "Get product by ID", description = "Retrieve a specific product by its ID")
    public ResponseEntity<Product> getProductById(@PathVariable Long id) {
        log.info("GET /api/products/{} - Fetching product by ID", id);
        Product product = productService.getProductById(id);
        return ResponseEntity.ok(product);
    }
    
    @GetMapping("/name/{name}")
    @Operation(summary = "Get product by name", description = "Retrieve a specific product by its name")
    public ResponseEntity<Product> getProductByName(@PathVariable String name) {
        log.info("GET /api/products/name/{} - Fetching product by name", name);
        Product product = productService.getProductByName(name);
        return ResponseEntity.ok(product);
    }
    
    @PostMapping
    @Operation(summary = "Create new product", description = "Create a new product in the inventory")
    public ResponseEntity<Product> createProduct(@Valid @RequestBody Product product) {
        log.info("POST /api/products - Creating new product: {}", product.getName());
        Product createdProduct = productService.createProduct(product);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdProduct);
    }
    
    @PutMapping("/{id}")
    @Operation(summary = "Update product", description = "Update an existing product in the inventory")
    public ResponseEntity<Product> updateProduct(@PathVariable Long id, @Valid @RequestBody Product productDetails) {
        log.info("PUT /api/products/{} - Updating product", id);
        Product updatedProduct = productService.updateProduct(id, productDetails);
        return ResponseEntity.ok(updatedProduct);
    }
    
    @DeleteMapping("/{id}")
    @Operation(summary = "Delete product", description = "Delete a product from the inventory")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
        log.info("DELETE /api/products/{} - Deleting product", id);
        productService.deleteProduct(id);
        return ResponseEntity.noContent().build();
    }
    
    @GetMapping("/category/{category}")
    @Operation(summary = "Get products by category", description = "Retrieve all products in a specific category")
    public ResponseEntity<List<Product>> getProductsByCategory(@PathVariable String category) {
        log.info("GET /api/products/category/{} - Fetching products by category", category);
        List<Product> products = productService.getProductsByCategory(category);
        return ResponseEntity.ok(products);
    }
    
    @GetMapping("/low-stock/{threshold}")
    @Operation(summary = "Get low stock products", description = "Retrieve products with quantity below the specified threshold")
    public ResponseEntity<List<Product>> getLowStockProducts(@PathVariable Integer threshold) {
        log.info("GET /api/products/low-stock/{} - Fetching low stock products", threshold);
        List<Product> products = productService.getLowStockProducts(threshold);
        return ResponseEntity.ok(products);
    }
    
    @GetMapping("/out-of-stock")
    @Operation(summary = "Get out of stock products", description = "Retrieve all products that are out of stock")
    public ResponseEntity<List<Product>> getOutOfStockProducts() {
        log.info("GET /api/products/out-of-stock - Fetching out of stock products");
        List<Product> products = productService.getOutOfStockProducts();
        return ResponseEntity.ok(products);
    }
    
    @GetMapping("/stats/in-stock-count")
    @Operation(summary = "Get in-stock product count", description = "Get the total number of products currently in stock")
    public ResponseEntity<Long> getInStockProductCount() {
        log.info("GET /api/products/stats/in-stock-count - Fetching in-stock product count");
        Long count = productService.getInStockProductCount();
        return ResponseEntity.ok(count);
    }
    
    @GetMapping("/stats/total-inventory")
    @Operation(summary = "Get total inventory count", description = "Get the total quantity of all products in inventory")
    public ResponseEntity<Long> getTotalInventoryCount() {
        log.info("GET /api/products/stats/total-inventory - Fetching total inventory count");
        Long count = productService.getTotalInventoryCount();
        return ResponseEntity.ok(count);
    }
} 