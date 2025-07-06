package com.devops.inventory.service;

import com.devops.inventory.model.Product;
import com.devops.inventory.repository.ProductRepository;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityNotFoundException;
import java.util.List;
import java.util.Optional;

@Service
@Slf4j
public class ProductService {
    
    private final ProductRepository productRepository;
    private final Counter productCreatedCounter;
    private final Counter productUpdatedCounter;
    private final Counter productDeletedCounter;
    
    @Autowired
    public ProductService(ProductRepository productRepository, MeterRegistry meterRegistry) {
        this.productRepository = productRepository;
        this.productCreatedCounter = Counter.builder("products_created_total")
                .description("Total number of products created")
                .register(meterRegistry);
        this.productUpdatedCounter = Counter.builder("products_updated_total")
                .description("Total number of products updated")
                .register(meterRegistry);
        this.productDeletedCounter = Counter.builder("products_deleted_total")
                .description("Total number of products deleted")
                .register(meterRegistry);
    }
    
    public List<Product> getAllProducts() {
        log.info("Fetching all products");
        return productRepository.findAll();
    }
    
    public Product getProductById(Long id) {
        log.info("Fetching product with id: {}", id);
        return productRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Product not found with id: " + id));
    }
    
    public Product getProductByName(String name) {
        log.info("Fetching product with name: {}", name);
        return productRepository.findByName(name)
                .orElseThrow(() -> new EntityNotFoundException("Product not found with name: " + name));
    }
    
    public Product createProduct(Product product) {
        log.info("Creating new product: {}", product.getName());
        Product savedProduct = productRepository.save(product);
        productCreatedCounter.increment();
        return savedProduct;
    }
    
    public Product updateProduct(Long id, Product productDetails) {
        log.info("Updating product with id: {}", id);
        Product product = getProductById(id);
        
        product.setName(productDetails.getName());
        product.setDescription(productDetails.getDescription());
        product.setPrice(productDetails.getPrice());
        product.setQuantity(productDetails.getQuantity());
        product.setCategory(productDetails.getCategory());
        product.setSku(productDetails.getSku());
        
        Product updatedProduct = productRepository.save(product);
        productUpdatedCounter.increment();
        return updatedProduct;
    }
    
    public void deleteProduct(Long id) {
        log.info("Deleting product with id: {}", id);
        if (!productRepository.existsById(id)) {
            throw new EntityNotFoundException("Product not found with id: " + id);
        }
        productRepository.deleteById(id);
        productDeletedCounter.increment();
    }
    
    public List<Product> getProductsByCategory(String category) {
        log.info("Fetching products by category: {}", category);
        return productRepository.findByCategory(category);
    }
    
    public List<Product> getLowStockProducts(Integer threshold) {
        log.info("Fetching products with quantity less than: {}", threshold);
        return productRepository.findByQuantityLessThan(threshold);
    }
    
    public List<Product> getOutOfStockProducts() {
        log.info("Fetching out of stock products");
        return productRepository.findOutOfStockProducts();
    }
    
    public Long getInStockProductCount() {
        return productRepository.countInStockProducts();
    }
    
    public Long getTotalInventoryCount() {
        return productRepository.getTotalInventoryCount();
    }
} 