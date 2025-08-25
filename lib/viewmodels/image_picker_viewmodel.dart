import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';

class ImagePickerState {
  final bool isLoading;
  final String? errorMessage;
  final File? selectedImage;

  const ImagePickerState({
    this.isLoading = false,
    this.errorMessage,
    this.selectedImage,
  });

  ImagePickerState copyWith({
    bool? isLoading,
    String? errorMessage,
    File? selectedImage,
  }) => ImagePickerState(
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage,
    selectedImage: selectedImage ?? this.selectedImage,
  );
}

class ImagePickerViewModel extends Notifier<ImagePickerState> {
  @override
  ImagePickerState build() {
    return ImagePickerState();
  }

  Future<void> pickImageFromGallery() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final viewModel = ref.read(profileViewModelProvider.notifier);
      final image = await viewModel.pickImageFromGallery();

      if (image == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Không có ảnh nào được chọn",
        );
        return;
      }

      state = state.copyWith(selectedImage: image);
      final imageUrl = await viewModel.uploadImage(image);

      if (imageUrl == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Không thể tải ảnh lên",
        );
        return;
      }

      viewModel.updateImageUrl(imageUrl);

      state = state.copyWith(isLoading: false, errorMessage: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Lỗi tải ảnh: ${e.toString()}",
      );
    }
  }

  Future<void> pickImageFromCamera() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final viewModel = ref.read(profileViewModelProvider.notifier);

      final image = await viewModel.pickImageFromCamera();

      if (image == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Không có ảnh nào được chọn",
        );
        return;
      }

      state = state.copyWith(selectedImage: image);
      final imageUrl = await viewModel.uploadImage(image);

      if (imageUrl == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Không thể tải ảnh",
        );
        return;
      }

      viewModel.updateImageUrl(imageUrl);
      state = state.copyWith(isLoading: false, errorMessage: null);
    } catch (e) {
      state = state.copyWith(
        errorMessage: "Lỗi tải ảnh: ${e.toString()}",
        isLoading: false,
      );
    }
  }

  void removeImage() {
    state = state.copyWith(selectedImage: null, errorMessage: null);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final imagePickerViewModelProvider =
    NotifierProvider<ImagePickerViewModel, ImagePickerState>(
      () => ImagePickerViewModel(),
    );
