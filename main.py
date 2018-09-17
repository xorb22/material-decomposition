# https://machinelearningmastery.com/tutorial-first-neural-network-python-keras/
from keras.models import Sequential
from keras.layers import Dense
import numpy
# fix random seed for reproducibility
numpy.random.seed(7)

# load pima indians dataset
dataset = numpy.loadtxt("calibrationPhantom_Io_120kVp_flux_1M.csv", delimiter=",")
# split into input (X) and output (Y) variables
X = dataset[:,2:]
Y = dataset[:,1:3]


# create model
model = Sequential()
model.add(Dense(12, input_dim=5, activation='relu'))
model.add(Dense(8, activation='relu'))
model.add(Dense(2))


# Compile model
model.compile(loss='mean_squared_error', optimizer='adam', metrics=['accuracy'])


# Fit the model
model.fit(X, Y, epochs=150, batch_size=10)
# model.fit(X, Y)

# evaluate the model
scores = model.evaluate(X, Y)
print("\n%s: %.2f%%" % (model.metrics_names[1], scores[1]*100))