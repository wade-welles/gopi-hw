# Go parameters
GOCMD=go
GOFLAGS=-tags "rpi"
GOINSTALL=$(GOCMD) install $(GOFLAGS)
GOTEST=$(GOCMD) test $(GOFLAGS) 
GOCLEAN=$(GOCMD) clean

# Freetype parameters
FT_CFLAGS=-I/usr/include/freetype2
FT_LDFLAGS=-lfreetype

# Raspberry Pi Firmware parameters
RPI_CFLAGS=-I/opt/vc/include -I/opt/vc/include/interface/vmcs_host
RPI_LDFLAGS=-L/opt/vc/lib -lbcm_host

#EGL
EGL_CFLAGS=-I/opt/vc/include -DUSE_VCHIQ_ARM
EGL_LDFLAGS=-L/opt/vc/lib -lEGL_static -lGLESv2_static -lkhrn_static -lvcos -lvchiq_arm -lbcm_host -lm

all: test_rpi test_egl test_freetype install

install:
	$(GOINSTALL) ./cmd/gpio_ctrl
	$(GOINSTALL) ./cmd/hw_list
	$(GOINSTALL) ./cmd/hw_service
	$(GOINSTALL) ./cmd/i2c_detect
	$(GOINSTALL) ./cmd/lirc_receive
	$(GOINSTALL) ./cmd/mmal_camera_preview
	$(GOINSTALL) ./cmd/mmal_encode_image
	$(GOINSTALL) ./cmd/pwm_ctrl
	$(GOINSTALL) ./cmd/spi_ctrl

test_rpi:
	CGO_CFLAGS="${RPI_CFLAGS}" CGO_LDFLAGS="${RPI_LDFLAGS}" $(GOTEST) -v ./rpi

test_egl:
	CGO_CFLAGS="${RPI_CFLAGS} ${EGL_CFLAGS}" CGO_LDFLAGS="${RPI_LDFLAGS} ${EGL_LDFLAGS}" $(GOTEST) -v ./egl

test_dx:
	CGO_CFLAGS="${RPI_CFLAGS}" CGO_LDFLAGS="${RPI_LDFLAGS}" $(GOTEST) -v ./rpi/dispmanx_test.go

test_freetype:
	CGO_CFLAGS="${FT_CFLAGS}" CGO_LDFLAGS="${FT_LDFLAGS}" $(GOTEST) -v ./freetype

clean: 
	$(GOCLEAN)
