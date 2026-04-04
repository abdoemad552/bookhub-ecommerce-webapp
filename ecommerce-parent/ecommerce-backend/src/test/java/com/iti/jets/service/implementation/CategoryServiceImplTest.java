package com.iti.jets.service.implementation;

import com.iti.jets.mapper.CategoryMapper;
import com.iti.jets.model.dto.response.CategoryDTO;
import com.iti.jets.model.entity.Category;
import com.iti.jets.repository.interfaces.CategoryRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CategoryServiceImpl Tests")
class CategoryServiceImplTest {

    @Mock
    private CategoryRepository categoryRepository;

    @Mock
    private CategoryMapper categoryMapper;

    @InjectMocks
    private CategoryServiceImpl categoryService;

    private Category mockCategory;
    private CategoryDTO mockCategoryDTO;

    @BeforeEach
    void setUp() {
        mockCategory = new Category();
        mockCategory.setId(1L);
        mockCategory.setName("Fiction");

        mockCategoryDTO = new CategoryDTO();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findById
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findById")
    class FindById {

        @Test
        @DisplayName("returns CategoryDTO when category exists")
        void returnsCategoryDTO_whenFound() {
            when(categoryRepository.findById(1L)).thenReturn(Optional.of(mockCategory));
            when(categoryMapper.toDTO(mockCategory)).thenReturn(mockCategoryDTO);

            CategoryDTO result = categoryService.findById(1L);

            assertNotNull(result);
            verify(categoryRepository).findById(1L);
            verify(categoryMapper).toDTO(mockCategory);
        }

        @Test
        @DisplayName("returns null when category does not exist")
        void returnsNull_whenNotFound() {
            when(categoryRepository.findById(99L)).thenReturn(Optional.empty());

            CategoryDTO result = categoryService.findById(99L);

            assertNull(result);
            verify(categoryMapper, never()).toDTO(any());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findAll
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findAll")
    class FindAll {

        @Test
        @DisplayName("returns mapped list of CategoryDTOs")
        void returnsMappedDTOs() {
            when(categoryRepository.findAll()).thenReturn(List.of(mockCategory));
            when(categoryMapper.toDTO(mockCategory)).thenReturn(mockCategoryDTO);

            List<CategoryDTO> result = categoryService.findAll();

            assertEquals(1, result.size());
        }

        @Test
        @DisplayName("returns empty list when no categories exist")
        void returnsEmptyList_whenNoneExist() {
            when(categoryRepository.findAll()).thenReturn(List.of());

            List<CategoryDTO> result = categoryService.findAll();

            assertTrue(result.isEmpty());
        }

        @Test
        @DisplayName("returns paged results")
        void returnsPaged_mappedDTOs() {
            when(categoryRepository.findAll(0, 5)).thenReturn(List.of(mockCategory));
            when(categoryMapper.toDTO(mockCategory)).thenReturn(mockCategoryDTO);

            List<CategoryDTO> result = categoryService.findAll(0, 5);

            assertEquals(1, result.size());
        }

        @Test
        @DisplayName("returns empty list when page has no results")
        void returnsEmptyList_whenPageEmpty() {
            when(categoryRepository.findAll(10, 5)).thenReturn(List.of());

            List<CategoryDTO> result = categoryService.findAll(10, 5);

            assertTrue(result.isEmpty());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // delete
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("delete")
    class Delete {

        @Test
        @DisplayName("deletes category when found")
        void deletesCategory_whenFound() {
            when(categoryRepository.findById(1L)).thenReturn(Optional.of(mockCategory));

            categoryService.delete(1L);

            verify(categoryRepository).delete(mockCategory);
        }

        @Test
        @DisplayName("does nothing when category not found")
        void doesNothing_whenNotFound() {
            when(categoryRepository.findById(99L)).thenReturn(Optional.empty());

            categoryService.delete(99L);

            verify(categoryRepository, never()).delete(any());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // count
    // ─────────────────────────────────────────────────────────────────────────
    @Test
    @DisplayName("count returns repository count")
    void count_returnsRepositoryCount() {
        when(categoryRepository.count()).thenReturn(7L);

        assertEquals(7L, categoryService.count());
    }

    // ─────────────────────────────────────────────────────────────────────────
    // existsById
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("existsById")
    class ExistsById {

        @Test
        @DisplayName("returns true when category exists")
        void returnsTrue_whenExists() {
            when(categoryRepository.existsById(1L)).thenReturn(true);

            assertTrue(categoryService.existsById(1L));
        }

        @Test
        @DisplayName("returns false when category does not exist")
        void returnsFalse_whenNotExists() {
            when(categoryRepository.existsById(99L)).thenReturn(false);

            assertFalse(categoryService.existsById(99L));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // filterExists
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("filterExists")
    class FilterExists {

        @Test
        @DisplayName("returns set of existing ids from given collection")
        void returnsExistingIds() {
            Collection<Long> input = List.of(1L, 2L, 99L);
            Set<Long> existing = Set.of(1L, 2L);

            when(categoryRepository.filterExists(input)).thenReturn(existing);

            Set<Long> result = categoryService.filterExists(input);

            assertEquals(existing, result);
        }

        @Test
        @DisplayName("returns empty set when none of the ids exist")
        void returnsEmptySet_whenNoneExist() {
            Collection<Long> input = List.of(50L, 60L);
            when(categoryRepository.filterExists(input)).thenReturn(Set.of());

            Set<Long> result = categoryService.filterExists(input);

            assertTrue(result.isEmpty());
        }
    }
}
